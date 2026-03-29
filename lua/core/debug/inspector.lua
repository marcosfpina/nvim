-- nvim/lua/core/debug/inspector.lua
-- Tools for inspecting Neovim state, LSP servers, VPN/proxy, and external API calls with MITM defense

local safe_require = require("core.debug.safe_require")
local logger_ok, logger_mod = safe_require("core.debug.logger")
local fallback = require("core.debug.fallback")
local config = require("core.debug.config")
local logger = (logger_ok and logger_mod.get_logger)
  and logger_mod.get_logger("core.debug.inspector")
  or fallback

local api = vim.api
local lsp = vim.lsp or {}
local uv = vim.loop

-- Optionally monitor external API/LLM calls
local api_monitor_ok, api_monitor = safe_require("core.debug.api_monitor")

local M = {}

-- Estado compartilhado para dashboard
local dashboard_state = {
  proxy_env = {},
  vpn_active = false,
  mitm_msgs = {},
}

--- Update network state (proxy/vpn detection)
local function update_network_state()
  -- VPN/Proxy Detection
  dashboard_state.proxy_env = {
    http  = os.getenv("HTTP_PROXY")  or os.getenv("http_proxy"),
    https = os.getenv("HTTPS_PROXY") or os.getenv("https_proxy"),
  }

  -- VPN detection via tun/tap interfaces
  dashboard_state.vpn_active = false
  local fh = uv.fs_open("/proc/net/dev", "r", 420)
  if fh then
    local data = uv.fs_read(fh, 65536, 0)
    uv.fs_close(fh)
    if data then
      for line in data:gmatch("[^\n]+") do
        if line:match("^%s*tun%d+:") or line:match("^%s*tap%d+:") then
          dashboard_state.vpn_active = true
          break
        end
      end
    end
  end

  -- MITM Defense: Certificate Fingerprint Validation
  dashboard_state.mitm_msgs = {}
  if api_monitor_ok and api_monitor.get_certificates then
    local certs = api_monitor.get_certificates()
    local expected_fingerprints = config.api_cert_fingerprints or {}
    for prov, cert in pairs(certs) do
      local expected = expected_fingerprints[prov]
      if expected then
        if cert.fingerprint ~= expected then
          table.insert(dashboard_state.mitm_msgs, string.format(
            "MITM ALERT %s: got %s expected %s",
            prov, cert.fingerprint, expected
          ))
        else
          table.insert(dashboard_state.mitm_msgs, string.format("%s cert valid", prov))
        end
      else
        table.insert(dashboard_state.mitm_msgs, string.format("%s cert not configured", prov))
      end
    end
  end
end

--- Inspect and log key Neovim state and external context
-- @param namespace string: logger namespace
-- @param context_msg string: optional context description
function M.inspect_state(namespace, context_msg)
  local ctx = context_msg or "Current"

  -- Update network state
  update_network_state()

  -- Neovim buffers/windows
  local buffers     = api.nvim_list_bufs()
  local windows     = api.nvim_list_wins()
  local current_buf = api.nvim_get_current_buf()
  local current_win = api.nvim_get_current_win()

  -- Active LSP Clients
  local clients = {}
  local get_clients = lsp.get_clients or lsp.get_active_clients -- Compat for newer Neovim
  if get_clients then
    for _, client in ipairs(get_clients()) do
      table.insert(clients, string.format(
        "%s(root=%s)",
        client.name,
        client.config and client.config.root_dir or "?"
      ))
    end
  end

  -- API Calls Stats per Provider
  local api_stats = api_monitor_ok and api_monitor.get_stats() or {}
  local providers = {"gemini", "anthropic", "grok", "mistral", "deepseek"}
  local apiMsgs = {}
  if api_monitor_ok then
    for _, prov in ipairs(providers) do
      local s = api_stats[prov] or {}
      table.insert(apiMsgs, string.format(
        "%s: total=%d errors=%d avg=%.1fms",
        prov, s.total or 0, s.errors or 0, s.avg_latency or 0.0
      ))
    end
  end

  -- Compose proxy messages
  local proxy_msgs = {}
  if dashboard_state.proxy_env.http or dashboard_state.proxy_env.https then
    table.insert(proxy_msgs, string.format(
      "Proxy: http=%s https=%s",
      dashboard_state.proxy_env.http or "-",
      dashboard_state.proxy_env.https or "-"
    ))
  else
    table.insert(proxy_msgs, "Proxy: none detected")
  end
  table.insert(proxy_msgs, dashboard_state.vpn_active and "VPN: active" or "VPN: not detected")

  -- Compose log message
  local parts = {
    string.format("%s State: Buf=%d Win=%d CurrBuf=%d CurrWin=%d",
      ctx, #buffers, #windows, current_buf, current_win),
    "LSP: " .. (#clients > 0 and table.concat(clients, ", ") or "none"),
    (api_monitor_ok and #apiMsgs > 0) and ("API: " .. table.concat(apiMsgs, "; ")) or nil,
    "Network: " .. table.concat(proxy_msgs, " | "),
    (#dashboard_state.mitm_msgs > 0) and ("MITM: " .. table.concat(dashboard_state.mitm_msgs, "; ")) or nil,
  }
  -- Filter nil parts
  local filtered_parts = vim.tbl_filter(function(v) return v ~= nil end, parts)
  local msg = table.concat(filtered_parts, "\n")

  -- Emit
  logger.info(namespace or "inspector", msg)
  return msg
end

--- Generate JSON state for dashboard
local function get_dashboard_state()
  update_network_state()
  
  local get_clients = lsp.get_clients or lsp.get_active_clients
  local lsp_clients = {}
  if get_clients then
    lsp_clients = vim.tbl_map(function(c) return c.name end, get_clients())
  end

  return vim.fn.json_encode({
    time = os.date("%Y-%m-%dT%H:%M:%SZ"),
    buffers = #api.nvim_list_bufs(),
    windows = #api.nvim_list_wins(),
    current_buffer = api.nvim_get_current_buf(),
    current_window = api.nvim_get_current_win(),
    lsp_clients = lsp_clients,
    api_stats = api_monitor_ok and api_monitor.get_stats() or {},
    network = { 
      proxy = dashboard_state.proxy_env, 
      vpn = dashboard_state.vpn_active 
    },
    mitm = dashboard_state.mitm_msgs,
    memory = collectgarbage("count"),
  })
end

--- Live Dashboard: HTTP server serving JSON state on localhost
-- @param port number: TCP port to serve
-- @return server handle or nil
function M.start_dashboard(port)
  port = port or 8080
  
  local server = uv.new_tcp()
  if not server then
    logger.error("inspector", "Failed to create TCP server")
    return nil
  end

  local ok, err = pcall(function()
    server:bind("127.0.0.1", port)
  end)
  
  if not ok then
    logger.error("inspector", "Failed to bind to port " .. port .. ": " .. tostring(err))
    return nil
  end

  server:listen(128, function(listen_err)
    if listen_err then
      logger.error("inspector", "Listen error: " .. tostring(listen_err))
      return
    end
    
    local client = uv.new_tcp()
    server:accept(client)
    
    client:read_start(function(read_err, data)
      if read_err then
        client:close()
        return
      end
      
      if data then
        -- Generate JSON payload
        local payload = get_dashboard_state()
        
        -- Write HTTP response
        local response = table.concat({
          "HTTP/1.1 200 OK",
          "Content-Type: application/json; charset=UTF-8",
          "Access-Control-Allow-Origin: *",
          "Content-Length: " .. tostring(#payload),
          "Connection: close",
          "",
          payload
        }, "\r\n")
        
        client:write(response, function()
          client:shutdown()
          client:close()
        end)
      else
        client:close()
      end
    end)
  end)
  
  logger.info("inspector", "Live dashboard running at http://127.0.0.1:" .. port)
  return server
end

--- Stop dashboard server
-- @param server handle returned by start_dashboard
function M.stop_dashboard(server)
  if server then
    server:close()
    logger.info("inspector", "Dashboard server stopped")
  end
end

--- Quick inspect command (for user command)
function M.quick_inspect()
  local result = M.inspect_state("quick", "User Requested")
  vim.notify(result, vim.log.levels.INFO)
end

return M
