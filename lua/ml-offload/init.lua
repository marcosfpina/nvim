-- ~/.config/nvim/lua/ml-offload/init.lua
-- ML Offload Neovim Plugin - Main Module

local curl = require("plenary.curl")
local M = {}

-- Default configuration
M.config = {
  api_url = "http://127.0.0.1:9000",
  timeout = 30000,
  model = "default",
  chat_defaults = {
    temperature = 0.7,
    max_tokens = 2000,
    stream = false,
  },
  ui = {
    border = "rounded",
    width = 0.8,
    height = 0.6,
  },
}

-- Setup function
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  
  -- Register commands
  vim.api.nvim_create_user_command("MLChat", function(args)
    M.chat(args.args)
  end, { nargs = "?", desc = "ML Offload: Chat with model" })
  
  vim.api.nvim_create_user_command("MLStatus", function()
    M.status()
  end, { desc = "ML Offload: Check API status" })
  
  vim.api.nvim_create_user_command("MLEmbed", function(args)
    M.embed(args.args)
  end, { nargs = "?", desc = "ML Offload: Get embeddings" })
  
  vim.api.nvim_create_user_command("MLModels", function()
    M.list_models()
  end, { desc = "ML Offload: List available models" })
  
  vim.notify("ML Offload: Initialized", vim.log.levels.INFO)
end

-- HTTP request helper
local function make_request(endpoint, method, body)
  local url = M.config.api_url .. endpoint
  
  local opts = {
    url = url,
    method = method or "GET",
    timeout = M.config.timeout,
    headers = {
      ["Content-Type"] = "application/json",
    },
  }
  
  if body then
    opts.body = vim.json.encode(body)
  end
  
  local response
  if method == "POST" then
    response = curl.post(opts)
  else
    response = curl.get(opts)
  end
  
  if response.status ~= 200 then
    return nil, "HTTP " .. response.status .. ": " .. response.body
  end
  
  local ok, data = pcall(vim.json.decode, response.body)
  if not ok then
    return nil, "Failed to parse JSON response"
  end
  
  return data, nil
end

-- Helper function to format backend status
local function format_backend_status(backends)
  local lines = {}
  
  if not backends then
    table.insert(lines, "  No backend information available")
    return lines
  end
  
  if backends.llamacpp then
    local status = backends.llamacpp
    local status_text = "unknown"
    
    if status.ready then
      status_text = "ready ✓"
    elseif status.available then
      status_text = "available (not ready)"
    else
      status_text = "unavailable ✗"
    end
    
    table.insert(lines, "  llamacpp: " .. status_text)
    
    if status.details then
      table.insert(lines, "    → " .. status.details)
    end
  else
    table.insert(lines, "  llamacpp: unknown")
  end
  
  return lines
end

-- Check API health status
function M.status()
  vim.notify("Checking ML Offload API status...", vim.log.levels.INFO)
  
  local data, err = make_request("/api/health", "GET")
  
  if err then
    vim.notify("ML Offload API Error: " .. err, vim.log.levels.ERROR)
    return
  end
  
  -- Create status buffer
  local buf = vim.api.nvim_create_buf(false, true)
  local win_width = math.floor(vim.o.columns * M.config.ui.width)
  local win_height = math.floor(vim.o.lines * M.config.ui.height)
  
  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    col = math.floor((vim.o.columns - win_width) / 2),
    row = math.floor((vim.o.lines - win_height) / 2),
    style = "minimal",
    border = M.config.ui.border,
  }
  
  local win = vim.api.nvim_open_win(buf, true, opts)
  
  -- Format status info
  local lines = {
    "═══════════════════════════════════════════════",
    "         ML OFFLOAD API STATUS",
    "═══════════════════════════════════════════════",
    "",
    "API URL: " .. M.config.api_url,
    "Status: " .. (data.status or "unknown"),
    "",
    "Backend Status:",
  }
  
  -- Add backend status lines
  local backend_lines = format_backend_status(data.backends)
  for _, line in ipairs(backend_lines) do
    table.insert(lines, line)
  end
  
  table.insert(lines, "")
  
  if data.details then
    table.insert(lines, "Details:")
    for key, value in pairs(data.details) do
      table.insert(lines, "  " .. key .. ": " .. vim.inspect(value))
    end
  end
  
  table.insert(lines, "")
  table.insert(lines, "Press 'q' or <Esc> to close")
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  
  -- Close on q or Esc
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
end

-- Chat completion
function M.chat(prompt)
  if not prompt or prompt == "" then
    -- Get visual selection or prompt user
    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" or mode == "\22" then
      -- Get visual selection
      vim.cmd('normal! "vy')
      prompt = vim.fn.getreg("v")
    else
      -- Prompt for input
      prompt = vim.fn.input("ML Chat> ")
      if prompt == "" then
        return
      end
    end
  end
  
  vim.notify("Sending chat request...", vim.log.levels.INFO)
  
  local body = {
    model = M.config.model,
    messages = {
      { role = "user", content = prompt }
    },
    temperature = M.config.chat_defaults.temperature,
    max_tokens = M.config.chat_defaults.max_tokens,
    stream = false,
  }
  
  local data, err = make_request("/v1/chat/completions", "POST", body)
  
  if err then
    vim.notify("Chat Error: " .. err, vim.log.levels.ERROR)
    return
  end
  
  -- Extract response
  local response_text = ""
  if data.choices and #data.choices > 0 then
    response_text = data.choices[1].message.content
  else
    response_text = "No response from model"
  end
  
  -- Display in floating window
  local buf = vim.api.nvim_create_buf(false, true)
  local win_width = math.floor(vim.o.columns * M.config.ui.width)
  local win_height = math.floor(vim.o.lines * M.config.ui.height)
  
  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    col = math.floor((vim.o.columns - win_width) / 2),
    row = math.floor((vim.o.lines - win_height) / 2),
    style = "minimal",
    border = M.config.ui.border,
  }
  
  local win = vim.api.nvim_open_win(buf, true, opts)
  
  -- Format response
  local lines = { "═══ ML CHAT RESPONSE ═══", "", "Prompt:", prompt, "", "Response:" }
  local response_lines = vim.split(response_text, "\n")
  vim.list_extend(lines, response_lines)
  table.insert(lines, "")
  table.insert(lines, "Press 'q' or <Esc> to close")
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  
  -- Close on q or Esc
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
end

-- Get embeddings
function M.embed(text)
  if not text or text == "" then
    -- Get visual selection
    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" or mode == "\22" then
      vim.cmd('normal! "vy')
      text = vim.fn.getreg("v")
    else
      text = vim.fn.input("Text to embed> ")
      if text == "" then
        return
      end
    end
  end
  
  vim.notify("Getting embeddings...", vim.log.levels.INFO)
  
  local body = {
    model = M.config.model,
    input = text,
  }
  
  local data, err = make_request("/v1/embeddings", "POST", body)
  
  if err then
    vim.notify("Embeddings Error: " .. err, vim.log.levels.ERROR)
    return
  end
  
  -- Show embedding info
  local embedding = data.data and data.data[1] and data.data[1].embedding or {}
  local dim = #embedding
  
  vim.notify(
    string.format("Embedding generated: %d dimensions", dim),
    vim.log.levels.INFO
  )
  
  return data
end

-- Embed visual selection
function M.embed_selection()
  vim.cmd('normal! "vy')
  local text = vim.fn.getreg("v")
  return M.embed(text)
end

-- List available models
function M.list_models()
  vim.notify("Fetching available models...", vim.log.levels.INFO)
  
  local data, err = make_request("/v1/models", "GET")
  
  if err then
    vim.notify("Models Error: " .. err, vim.log.levels.ERROR)
    return
  end
  
  -- Display models
  local buf = vim.api.nvim_create_buf(false, true)
  local win_width = math.floor(vim.o.columns * 0.6)
  local win_height = math.floor(vim.o.lines * 0.5)
  
  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    col = math.floor((vim.o.columns - win_width) / 2),
    row = math.floor((vim.o.lines - win_height) / 2),
    style = "minimal",
    border = M.config.ui.border,
  }
  
  local win = vim.api.nvim_open_win(buf, true, opts)
  
  local lines = { "═══ AVAILABLE MODELS ═══", "" }
  
  if data.data then
    for _, model in ipairs(data.data) do
      table.insert(lines, "• " .. (model.id or "unknown"))
    end
  else
    table.insert(lines, "No models available")
  end
  
  table.insert(lines, "")
  table.insert(lines, "Press 'q' or <Esc> to close")
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  
  -- Close on q or Esc
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
end

return M
