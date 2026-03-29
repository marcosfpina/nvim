-- lua/core/debug/logger.lua
local config = require("core.debug.config")
local fallback = require("core.debug.fallback")

-- Cache de módulos com fallback visual
local _mod_cache = {}
local function safe_require(path)
  if _mod_cache[path] ~= nil then return _mod_cache[path] end

  local ok, mod = pcall(require, path)
  if not ok then
    vim.schedule(function()
      vim.notify("🔧 safe_require: Failed to load " .. path .. ": " .. tostring(mod), vim.log.levels.ERROR) 
    end)
    _mod_cache[path] = false
    return nil
  end
  _mod_cache[path] = mod
  return mod
end

-- Fallback icons - always available
local fallback_icons = {
  levels = {
    DEBUG = "🐛",
    INFO = "ℹ️ ",
    WARN = "⚠️ ",
    ERROR = "💥",
    TRACE = "🔍",
    FATAL = "💀"
  },
  misc = {
    CheckboxChecked = "✓",
    Warning = "⚠️ "
  }
}

-- Load user icons with safe fallback
local user_icons = safe_require("core.icons")
local icons = {}

-- Safely merge icons with fallback
if user_icons and type(user_icons) == "table" then
  icons.levels = (user_icons.levels and type(user_icons.levels) == "table") 
    and user_icons.levels 
    or fallback_icons.levels
  icons.misc = (user_icons.misc and type(user_icons.misc) == "table") 
    and user_icons.misc 
    or fallback_icons.misc
else
  icons = fallback_icons
end

local M = {}
local buffer = {}
local ns_colors = {}

-- Configuração padrão extendida
config = vim.tbl_deep_extend("force", {
  enabled = true,
  buffer_size = 100,
  log_file = vim.fn.stdpath("cache") .. "/kernel_debug.log",
  colors = {
    DEBUG = "#89B4FA",
    INFO = "#94E2D5",
    WARN = "#F9E2AF",
    ERROR = "#F38BA8",
    TRACE = "#B4BEFE",
    FATAL = "#FAB387"
  }
}, config or {})

-- Níveis de log com metadados
local Levels = { 
  DEBUG = { icon = icons.levels.DEBUG, color = config.colors.DEBUG },
  INFO = { icon = icons.levels.INFO, color = config.colors.INFO },
  WARN = { icon = icons.levels.WARN, color = config.colors.WARN },
  ERROR = { icon = icons.levels.ERROR, color = config.colors.ERROR },
  TRACE = { icon = icons.levels.TRACE, color = config.colors.TRACE },
  FATAL = { icon = icons.levels.FATAL, color = config.colors.FATAL }
}

-- Gera cor única para cada namespace
local function get_ns_color(ns)
  if not ns_colors[ns] then
    local hash = 0
    for i = 1, #ns do 
      hash = hash + ns:byte(i) 
    end
    ns_colors[ns] = string.format("#%06x", (hash * 127) % 0xFFFFFF)
  end
  return ns_colors[ns]
end

-- Setup highlight groups
local function setup_highlights()
  for level, meta in pairs(Levels) do
    vim.api.nvim_set_hl(0, "KernelLC" .. level, { fg = meta.color, bold = true })
  end
  vim.api.nvim_set_hl(0, "KernelLCNS", { fg = "#CDD6F4", italic = true })
end

-- Call setup on module load
vim.schedule(setup_highlights)

-- Função de log unificada
local function log(level, ns, msg, opts)
  if not config.enabled then return end
  
  -- Validate level
  if not Levels[level] then
    level = "WARN"
    msg = "Invalid log level used: " .. tostring(msg)
  end

  local entry = {
    timestamp = os.date("%H:%M:%S"),
    level = level,
    ns = ns or "unknown",
    msg = tostring(msg),
    thread = (opts and opts.thread) or "main"
  }

  -- Formatação visual rica
  local colored_line = string.format(
    "%%#%s#%s %%#KernelLCNS#[%s] %%#Normal#%s",
    "KernelLC" .. level,
    Levels[level].icon,
    entry.ns,
    entry.msg
  )

  table.insert(buffer, {
    raw = entry,
    display = colored_line
  })

  -- Auto-flush se buffer cheio
  if #buffer >= config.buffer_size then 
    M.flush() 
  end

  -- Echo imediato no Neovim (non-blocking)
  vim.schedule(function()
    pcall(vim.api.nvim_echo, {{colored_line}}, false, {})
  end)
end

-- Métodos públicos
function M.flush()
  if #buffer == 0 then return end
  
  local ok, file = pcall(vim.loop.fs_open, config.log_file, "a", 420)
  if not ok or not file then 
    -- Use fallback if available, otherwise silent fail
    if fallback and fallback.error then
      fallback.error("Failed to open log file: " .. config.log_file)
    end
    return 
  end

  local lines = {}
  for _, entry in ipairs(buffer) do
    table.insert(lines, string.format("[%s] %-5s [%s] %s",
      entry.raw.timestamp,
      entry.raw.level,
      entry.raw.ns,
      entry.raw.msg))
  end

  pcall(vim.loop.fs_write, file, table.concat(lines, "\n") .. "\n", -1)
  pcall(vim.loop.fs_close, file)

  -- Centralized Error Logging
  -- Filter and write ERROR/FATAL logs to a separate file
  local error_lines = {}
  for _, entry in ipairs(buffer) do
    if entry.raw.level == "ERROR" or entry.raw.level == "FATAL" then
      table.insert(error_lines, string.format("[%s] %-5s [%s] %s",
        entry.raw.timestamp,
        entry.raw.level,
        entry.raw.ns,
        entry.raw.msg))
    end
  end

  if #error_lines > 0 and config.error_log_file then
    local ok_err, err_file = pcall(vim.loop.fs_open, config.error_log_file, "a", 420)
    if ok_err and err_file then
      pcall(vim.loop.fs_write, err_file, table.concat(error_lines, "\n") .. "\n", -1)
      pcall(vim.loop.fs_close, err_file)
    end
  end

  buffer = {}
end

-- Enhanced logger with both simple and advanced functionality
function M.get_logger(logger_name)
  local name = logger_name or "default"
  
  local function format_message(level, message_content)
    return string.format("[%s] %s: %s", name, level, tostring(message_content))
  end

  local function log_with_highlight(level, message, hl_group)
    local formatted_msg = format_message(level, message)
    vim.schedule(function()
      vim.api.nvim_echo({{formatted_msg, hl_group or "Normal"}}, true, {})
    end)
    return formatted_msg
  end

  return {
    info = function(message)
      return log_with_highlight("INFO", message, "Normal")
    end,
    warn = function(message)
      return log_with_highlight("WARN", message, "WarningMsg")
    end,
    error = function(message)
      return log_with_highlight("ERROR", message, "ErrorMsg")
    end,
    debug = function(message)
      if vim.g.debug_mode then
        return log_with_highlight("DEBUG", message, "Comment")
      end
    end,
    -- Advanced logging features
    trace = function(message, context)
      if vim.g.debug_mode then
        local ctx_str = context and string.format(" [%s]", vim.inspect(context)) or ""
        return log_with_highlight("TRACE", message .. ctx_str, "Comment")
      end
    end,
    performance = function(message, start_time)
      if vim.g.debug_mode and start_time then
        local elapsed = vim.loop.now() - start_time
        return log_with_highlight("PERF", string.format("%s (%.2fms)", message, elapsed), "Special")
      end
    end
  }
end

-- Initialize global logger
M.global = M.get_logger("Neovim")

-- Métodos de conveniência
function M.debug(ns, msg, opts) log("DEBUG", ns, msg, opts) end
function M.info(ns, msg, opts) log("INFO", ns, msg, opts) end
function M.warn(ns, msg, opts) log("WARN", ns, msg, opts) end
function M.error(ns, msg, opts) log("ERROR", ns, msg, opts) end
function M.trace(ns, msg, opts) log("TRACE", ns, msg, opts) end

function M.fatal(ns, msg, opts)
  log("FATAL", ns, msg, opts)
  M.flush()
  error(tostring(msg))
end

-- Status e configuração
function M.is_enabled() return config.enabled end
function M.enable() config.enabled = true end
function M.disable() config.enabled = false end
function M.get_config() return vim.deepcopy(config) end

-- Inicialização automática
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    pcall(M.flush)
  end,
  desc = "Flush debug logs on exit"
})

return M
