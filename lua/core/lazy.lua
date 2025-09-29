-- ~/.config/nvim/lua/core/lazy.lua

-- Lazy.nvim plugin manager setup with NixOS compatibility

-- Detect NixOS environment
local is_nixos = vim.fn.executable("nix") == 1 or vim.env.NIX_PATH ~= nil

-- Bootstrap lazy.nvim if not installed (NixOS compatible)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is available before trying to use it
local lazy_available = false

-- Try to find lazy.nvim in different locations
if vim.loop.fs_stat(lazypath) then
  vim.opt.rtp:prepend(lazypath)
  lazy_available = pcall(require, "lazy")
else
  -- Try system-installed lazy.nvim (NixOS)
  lazy_available = pcall(require, "lazy")

  if not lazy_available then
    if is_nixos then
      vim.notify("NixOS detected - Consider installing lazy.nvim through system config", vim.log.levels.WARN, { title = "Lazy.nvim" })
      return -- Exit early on NixOS if lazy.nvim not available
    else
      vim.notify("Installing lazy.nvim...", vim.log.levels.INFO, { title = "Lazy.nvim" })
      vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
      })
      vim.opt.rtp:prepend(lazypath)
      lazy_available = pcall(require, "lazy")
    end
  end
end

-- Exit early if lazy.nvim is not available
if not lazy_available then
  vim.notify("Lazy.nvim not available - running without plugin manager", vim.log.levels.WARN)
  return
end

-- Load the plugin manager

-- Safe plugin loading function
local function safe_import(module_name, description)
  local module_path = "plugins." .. module_name
  local ok, _ = pcall(require, module_path)
  if ok then
    return { import = module_path }
  else
    if is_nixos then
      vim.notify("Plugin module '" .. module_name .. "' not found (NixOS environment)", vim.log.levels.DEBUG)
    end
    return nil
  end
end

-- Build plugin spec table with only existing modules
local plugin_specs = {}

-- Add existing plugin modules
local existing_modules = {
  { name = "ui", desc = "UI enhancements" },
  { name = "lsp", desc = "Language Server Protocol" },
}

for _, module in ipairs(existing_modules) do
  local spec = safe_import(module.name, module.desc)
  if spec then
    table.insert(plugin_specs, spec)
  end
end

-- Future modules (commented out until they exist)
--[[
local future_modules = {
  { name = "editing", desc = "Editing and text manipulation" },
  { name = "git", desc = "Git integration" },
  { name = "nav", desc = "Navigation and file management" },
  { name = "coding", desc = "Coding assistance (completion, snippets, etc.)" },
  { name = "debug", desc = "Debugging" },
  { name = "lang", desc = "Language-specific plugins" },
  { name = "tools", desc = "Additional tools and utilities" },
  { name = "ai", desc = "AI-powered assistance" },
}

for _, module in ipairs(future_modules) do
  local spec = safe_import(module.name, module.desc)
  if spec then
    table.insert(plugin_specs, spec)
  end
end
--]]

require("lazy").setup(plugin_specs, {
  defaults = {
    lazy = true, -- By default, load plugins on use
  },

  install = {
    colorscheme = { "tokyonight", "habamax" },
  },

  checker = {
    enabled = not is_nixos, -- Disable checker on NixOS (managed by system)
    frequency = 86400, -- Check once a day
    notify = false, -- Don't notify about updates
  },

  change_detection = {
    enabled = true,
    notify = false,
  },

performance = {

cache = {

enabled = true,

},

reset_packpath = true,

rtp = {

reset = true,

disabled_plugins = {

"gzip",

"matchit",

"matchparen",

"netrwPlugin",

"tarPlugin",

"tohtml",

"tutor",

"zipPlugin",

},

},

},

ui = {

border = "rounded",

size = {

width = 0.8,

height = 0.8,

},

icons = {

cmd = " ",

config = " ",

event = " ",

ft = " ",

init = " ",

keys = " ",

plugin = " ",

runtime = " ",

source = " ",

start = " ",

task = " ",

lazy = "󰒲 ",

},

},

debug = false,

})
