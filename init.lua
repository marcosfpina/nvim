--[[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

Production-Grade Neovim Configuration
Optimized for Performance, Reliability, and Maintainability

Author: Advanced Neovim User
Repository: https://github.com/VoidNxSEC/nvim
Last Updated: 2025

Features:
- Intelligent module loading with dependency management
- Production-grade error handling and recovery
- Performance profiling and monitoring
- Environment-aware configuration
- Graceful degradation strategies
- Comprehensive logging infrastructure
- Health check system
- Development mode support
--]]

--------------------------------------------------------------------------------
-- BOOTSTRAP: Pre-initialization and Environment Detection
--------------------------------------------------------------------------------

-- Performance tracking
local bootstrap_start = vim.loop.hrtime()

-- Global configuration state
_G.nvim_config = {
  version = "2.0.0",
  start_time = bootstrap_start,
  environment = {
    is_nixos = vim.fn.executable("nix") == 1 or vim.env.NIX_PATH ~= nil,
    is_wsl = vim.fn.has("wsl") == 1,
    is_ssh = vim.env.SSH_CONNECTION ~= nil,
    is_dev_mode = vim.env.NVIM_DEV_MODE == "1",
  },
  state = {
    core_loaded = false,
    plugins_loaded = false,
    errors = {},
    warnings = {},
  },
  metrics = {
    module_load_times = {},
  },
}

-- Early leader key setup (must be done before any mappings)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--------------------------------------------------------------------------------
-- LOGGING INFRASTRUCTURE
--------------------------------------------------------------------------------

local log_levels = {
  TRACE = 0,
  DEBUG = 1,
  INFO = 2,
  WARN = 3,
  ERROR = 4,
  FATAL = 5,
}

local log_level = _G.nvim_config.environment.is_dev_mode and log_levels.DEBUG or log_levels.WARN

_G.log = {
  trace = function(msg, data)
    if log_level <= log_levels.TRACE then
      vim.notify("[TRACE] " .. msg, vim.log.levels.TRACE, { title = "Neovim Config" })
      if data then print(vim.inspect(data)) end
    end
  end,
  debug = function(msg, data)
    if log_level <= log_levels.DEBUG then
      vim.notify("[DEBUG] " .. msg, vim.log.levels.DEBUG, { title = "Neovim Config" })
      if data then print(vim.inspect(data)) end
    end
  end,
  info = function(msg)
    if log_level <= log_levels.INFO then
      vim.notify("[INFO] " .. msg, vim.log.levels.INFO, { title = "Neovim Config" })
    end
  end,
  warn = function(msg)
    if log_level <= log_levels.WARN then
      vim.notify("[WARN] " .. msg, vim.log.levels.WARN, { title = "Neovim Config" })
      table.insert(_G.nvim_config.state.warnings, { time = os.date("%Y-%m-%d %H:%M:%S"), msg = msg })
    end
  end,
  error = function(msg, err)
    if log_level <= log_levels.ERROR then
      vim.notify("[ERROR] " .. msg, vim.log.levels.ERROR, { title = "Neovim Config" })
      table.insert(_G.nvim_config.state.errors, { time = os.date("%Y-%m-%d %H:%M:%S"), msg = msg, err = err })
    end
  end,
  fatal = function(msg, err)
    vim.notify("[FATAL] " .. msg, vim.log.levels.ERROR, { title = "Neovim Config" })
    table.insert(_G.nvim_config.state.errors, { time = os.date("%Y-%m-%d %H:%M:%S"), msg = msg, err = err, fatal = true })
  end,
}

--------------------------------------------------------------------------------
-- MODULE LOADER WITH PROFILING AND ERROR RECOVERY
--------------------------------------------------------------------------------

---@class ModuleLoader
---@field load fun(module: string, opts: table?): boolean, any
local ModuleLoader = {}

---Load a module with comprehensive error handling and profiling
---@param module_name string The module to load (e.g., "core.options")
---@param opts table? Optional configuration { required: boolean, description: string, retry: boolean }
---@return boolean success, any result
function ModuleLoader.load(module_name, opts)
  opts = opts or {}
  local description = opts.description or module_name
  local required = opts.required or false
  local retry_on_failure = opts.retry or false

  _G.log.debug("Loading module: " .. description)

  local start_time = vim.loop.hrtime()
  local success, result = pcall(require, module_name)
  local end_time = vim.loop.hrtime()
  local load_time = (end_time - start_time) / 1e6 -- Convert to milliseconds

  -- Store metrics
  _G.nvim_config.metrics.module_load_times[module_name] = load_time

  if success then
    _G.log.debug(string.format("✓ Loaded %s (%.2fms)", description, load_time))
    return true, result
  else
    local error_msg = string.format("Failed to load %s: %s", description, result)

    if required then
      _G.log.fatal(error_msg, result)
      -- For critical modules, we might want to show a more prominent error
      vim.api.nvim_err_writeln("CRITICAL ERROR: " .. error_msg)
    else
      _G.log.error(error_msg, result)
    end

    -- Retry logic for non-critical modules
    if retry_on_failure and not required then
      _G.log.warn("Attempting retry for " .. description)
      vim.defer_fn(function()
        pcall(require, module_name)
      end, 1000)
    end

    return false, result
  end
end

---Load multiple modules in sequence
---@param modules table Array of module configurations
---@return boolean all_success
function ModuleLoader.load_sequence(modules)
  local all_success = true
  for _, mod_config in ipairs(modules) do
    local success = ModuleLoader.load(mod_config.module, mod_config.opts)
    if not success and (mod_config.opts and mod_config.opts.required) then
      all_success = false
      break
    end
  end
  return all_success
end

--------------------------------------------------------------------------------
-- HEALTH CHECK SYSTEM
--------------------------------------------------------------------------------

local HealthCheck = {
  checks = {},
  passed = 0,
  failed = 0,
  warnings = 0,
}

---Register a health check
---@param name string Name of the check
---@param check_fn function Function that returns boolean and optional message
function HealthCheck.register(name, check_fn)
  table.insert(HealthCheck.checks, { name = name, fn = check_fn })
end

---Run all health checks
function HealthCheck.run_all()
  _G.log.debug("Running health checks...")

  for _, check in ipairs(HealthCheck.checks) do
    local success, result = pcall(check.fn)
    if success and result then
      HealthCheck.passed = HealthCheck.passed + 1
      _G.log.trace("✓ Health check passed: " .. check.name)
    else
      HealthCheck.failed = HealthCheck.failed + 1
      _G.log.warn("✗ Health check failed: " .. check.name .. " - " .. tostring(result))
    end
  end

  if HealthCheck.failed > 0 then
    _G.log.warn(string.format("Health checks: %d passed, %d failed", HealthCheck.passed, HealthCheck.failed))
  else
    _G.log.debug(string.format("All health checks passed (%d)", HealthCheck.passed))
  end
end

-- Register basic health checks
HealthCheck.register("Vim API availability", function()
  return vim.api ~= nil
end)

HealthCheck.register("Standard paths", function()
  return vim.fn.stdpath("config") ~= nil and vim.fn.stdpath("data") ~= nil
end)

HealthCheck.register("Clipboard support", function()
  return vim.fn.has("clipboard") == 1
end)

--------------------------------------------------------------------------------
-- CORE MODULE INITIALIZATION
--------------------------------------------------------------------------------

_G.log.info("Initializing Neovim configuration v" .. _G.nvim_config.version)
_G.log.debug("Environment: " .. vim.inspect(_G.nvim_config.environment))

-- Run health checks
HealthCheck.run_all()

-- Define core modules to load
local core_modules = {
  {
    module = "core.options",
    opts = { required = true, description = "Core options and settings" }
  },
  {
    module = "core.keymaps",
    opts = { required = true, description = "Core keymaps" }
  },
  {
    module = "core.autocmds",
    opts = { required = false, description = "Core autocommands" }
  },
}

-- Load core modules
_G.log.info("Loading core modules...")
local core_success = ModuleLoader.load_sequence(core_modules)

if core_success then
  _G.nvim_config.state.core_loaded = true
  _G.log.info("✓ Core modules loaded successfully")
else
  _G.log.fatal("Failed to load critical core modules")
end

pcall(function()
  require("core.notify").install()
end)

--------------------------------------------------------------------------------
-- UTILITIES INITIALIZATION
--------------------------------------------------------------------------------

local utils_success, utils = ModuleLoader.load("core.utils", {
  description = "Core utilities",
  required = false,
})

if utils_success then
  _G.utils = utils
else
  -- Provide minimal fallback utilities
  _G.utils = {
    notify = function(msg, level)
      vim.notify(msg, level or vim.log.levels.INFO)
    end,
    is_available = function(plugin)
      local ok, _ = pcall(require, plugin)
      return ok
    end,
  }
  _G.log.warn("Using fallback utilities")
end

--------------------------------------------------------------------------------
-- PLUGIN MANAGER INITIALIZATION
--------------------------------------------------------------------------------

_G.log.info("Initializing plugin manager...")

local lazy_success = ModuleLoader.load("core.lazy", {
  description = "Plugin manager (lazy.nvim)",
  required = false,
})

if not lazy_success then
  if _G.nvim_config.environment.is_nixos then
    _G.log.info("Running in NixOS mode without lazy.nvim (managed by system)")
  else
    _G.log.warn("Plugin manager not available - running in minimal mode")
  end
end

--------------------------------------------------------------------------------
-- PLUGIN CONFIGURATIONS
--------------------------------------------------------------------------------

_G.log.info("Loading plugin configurations...")

local plugins_success = ModuleLoader.load("plugins", {
  description = "Plugin configurations",
  required = false,
})

if plugins_success then
  _G.nvim_config.state.plugins_loaded = true
  _G.log.info("✓ Plugin configurations loaded")
else
  if _G.nvim_config.environment.is_nixos then
    _G.log.info("Plugin configurations handled by NixOS")
  else
    _G.log.warn("Plugin configurations not loaded")
  end
end

--------------------------------------------------------------------------------
-- POST-INITIALIZATION AND FINALIZATION
--------------------------------------------------------------------------------

-- Calculate total startup time
local bootstrap_end = vim.loop.hrtime()
local total_time = (bootstrap_end - bootstrap_start) / 1e6 -- Convert to milliseconds

_G.nvim_config.metrics.total_startup_time = total_time

-- Log startup summary
_G.log.info(string.format("Configuration loaded in %.2fms", total_time))

if _G.nvim_config.environment.is_dev_mode then
  _G.log.debug("Module load times:")
  for module, time in pairs(_G.nvim_config.metrics.module_load_times) do
    _G.log.debug(string.format("  %s: %.2fms", module, time))
  end
end

-- Provide status command for users
vim.api.nvim_create_user_command("NvimConfigStatus", function()
  local lines = {
    "Neovim Configuration Status",
    "Version: " .. _G.nvim_config.version,
    "",
    "Environment:",
    "  NixOS: " .. tostring(_G.nvim_config.environment.is_nixos),
    "  WSL: " .. tostring(_G.nvim_config.environment.is_wsl),
    "  SSH: " .. tostring(_G.nvim_config.environment.is_ssh),
    "  Dev Mode: " .. tostring(_G.nvim_config.environment.is_dev_mode),
    "",
    "State:",
    "  Core Loaded: " .. tostring(_G.nvim_config.state.core_loaded),
    "  Plugins Loaded: " .. tostring(_G.nvim_config.state.plugins_loaded),
    "  Errors: " .. #_G.nvim_config.state.errors,
    "  Warnings: " .. #_G.nvim_config.state.warnings,
    "",
    string.format("Startup Time: %.2fms", _G.nvim_config.metrics.total_startup_time),
  }

  if #_G.nvim_config.state.errors > 0 then
    table.insert(lines, "")
    table.insert(lines, "Recent Errors:")
    for _, err in ipairs(_G.nvim_config.state.errors) do
      table.insert(lines, "  [" .. err.time .. "] " .. err.msg)
    end
  end

  if #_G.nvim_config.state.warnings > 0 then
    table.insert(lines, "")
    table.insert(lines, "Recent Warnings:")
    for _, warn in ipairs(_G.nvim_config.state.warnings) do
      table.insert(lines, "  [" .. warn.time .. "] " .. warn.msg)
    end
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

  local width = 80
  local height = math.min(#lines + 2, vim.o.lines - 4)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = "minimal",
    border = "rounded",
    title = " Neovim Config Status ",
    title_pos = "center",
  })

  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
end, { desc = "Show Neovim configuration status" })

-- Success message
if #_G.nvim_config.state.errors == 0 then
  _G.log.info("✅ Neovim configuration initialized successfully")
else
  _G.log.warn(string.format("⚠️  Neovim started with %d errors", #_G.nvim_config.state.errors))
  _G.log.warn("Run :NvimConfigStatus for details")
end

-- Defer non-critical initialization to improve perceived startup time
vim.defer_fn(function()
  _G.log.debug("Deferred initialization complete")
end, 100)

-- Disable unnecessary providers to speed up startup
vim.g.loaded_python3_provider = 1
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

--------------------------------------------------------------------------------
-- DEBUG & FORENSIC TOOLS
--------------------------------------------------------------------------------
-- Lazy-load debug system (call :DebugEnable to activate full features)
pcall(function()
  local debug_cmds = require("core.debug.commands")
  if debug_cmds and debug_cmds.setup then
    debug_cmds.setup()
  end
end)
