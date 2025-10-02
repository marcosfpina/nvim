--[[

███╗ ██╗███████╗ ██████╗ ██╗ ██╗██╗███╗ ███╗

████╗ ██║██╔════╝██╔═══██╗██║ ██║██║████╗ ████║

██╔██╗ ██║█████╗ ██║ ██║██║ ██║██║██╔████╔██║

██║╚██╗██║██╔══╝ ██║ ██║╚██╗ ██╔╝██║██║╚██╔╝██║

██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║

╚═╝ ╚═══╝╚══════╝ ╚═════╝ ╚═══╝ ╚═╝╚═╝ ╚═╝

Neovim Configuration for Linux Mint with Alacritty terminal

Optimized for Development in 2025

Author: Advanced Neovim User

Repository: https://github.com/marcosfpina/neotron

Last updated: 2025

--]]

--------------------------------------------------------------------------------

-- CORE SETTINGS

--------------------------------------------------------------------------------

-- Initialize globals and leader keys

vim.g.mapleader = " "

vim.g.maplocalleader = "\\"

-- Load core modules with safety checks

-- Safe require function for better error handling
local function safe_require(module_name, description)
  local ok, result = pcall(require, module_name)
  if not ok then
    vim.notify("Failed to load " .. (description or module_name) .. ": " .. result, vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Load core modules in order
if not safe_require("core.options", "core options") then
  vim.notify("Critical: Core options failed to load", vim.log.levels.ERROR)
end

if not safe_require("core.keymaps", "core keymaps") then
  vim.notify("Warning: Core keymaps failed to load", vim.log.levels.WARN)
end

if not safe_require("core.autocmds", "core autocommands") then
  vim.notify("Warning: Core autocommands failed to load", vim.log.levels.WARN)
end

-- Plugin manager setup (with fallback)
if not safe_require("core.lazy", "plugin manager (lazy.nvim)") then
  vim.notify("Warning: Plugin manager failed to load - running without plugins", vim.log.levels.WARN)
end

-- Initialize any global utilities
if safe_require("core.utils", "core utilities") then
  _G.utils = require("core.utils")
else
  -- Provide minimal fallback utils
  _G.utils = {
    notify = vim.notify,
    is_available = function() return false end
  }
end

-- Finally require all plugin configurations (with fallback)
if not safe_require("plugins", "plugin configurations") then
  vim.notify("Info: Plugin configurations not loaded (may be managed by NixOS)", vim.log.levels.INFO)
end

