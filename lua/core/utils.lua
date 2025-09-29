-- ~/.config/nvim/lua/core/utils.lua

-- Utility functions for the Neovim configuration

local M = {}

-- Enhanced notification function with smart level detection

---@param msg string Message to display

---@param level? string|number Log level: "error", "warn", "info", "debug", "trace" or vim.log.levels values

---@param opts? table Additional options for vim.notify

function M.notify(msg, level, opts)

level = level or vim.log.levels.INFO

opts = opts or {}

-- Convert string levels to vim.log.levels

if type(level) == "string" then

level = ({

error = vim.log.levels.ERROR,

warn = vim.log.levels.WARN,

info = vim.log.levels.INFO,

debug = vim.log.levels.DEBUG,

trace = vim.log.levels.TRACE,

})[string.lower(level)] or vim.log.levels.INFO

end

-- Set default title based on level if not specified

if not opts.title then

opts.title = ({

[vim.log.levels.ERROR] = "Error",

[vim.log.levels.WARN] = "Warning",

[vim.log.levels.INFO] = "Information",

[vim.log.levels.DEBUG] = "Debug",

[vim.log.levels.TRACE] = "Trace",

})[level] or "Notification"

end

vim.notify(msg, level, opts)

end

-- Check if a plugin is available

---@param plugin string The plugin name

---@return boolean available Whether the plugin is available

function M.is_available(plugin)

local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")

if not lazy_config_avail then

return false

end

return lazy_config.spec.plugins[plugin] ~= nil

end

-- Execute a command and capture the output

---@param cmd string The command to execute

---@param show_error boolean Whether to show errors (defaults to true)

---@return string|nil stdout The standard output or nil on error

---@return string|nil stderr The error output or nil on success

function M.cmd(cmd, show_error)

if show_error == nil then show_error = true end

local stdout = vim.fn.system(cmd)

local exit_code = vim.v.shell_error

if exit_code ~= 0 and show_error then

local stderr = "Command failed: " .. cmd .. "\nExit code: " .. exit_code

M.notify(stderr, "error", { title = "Shell Command Error" })

return nil, stderr

end

return stdout, nil

end

-- Toggle a boolean option

---@param option string The option to toggle

---@param silent boolean Whether to suppress notifications (defaults to false)

function M.toggle_option(option, silent)

local value = not vim.api.nvim_get_option_value(option, {})

vim.api.nvim_set_option_value(option, value, {})

if not silent then

M.notify(

option .. " " .. (value and "enabled" or "disabled"),

"info",

{ title = "Option Toggled" }

)

end

return value

end

-- Create a toggling function for options

---@param option string The option to toggle

---@return function toggle_func The toggle function

function M.toggle_factory(option)

return function()

M.toggle_option(option)

end

end

-- Get the root directory of the current project

---@return string|nil root The root directory or nil if not found

function M.get_root()

-- Try getting the root from LSP

local clients = vim.lsp.get_active_clients()

if vim.tbl_isempty(clients) then

return vim.fn.getcwd()

end

local bufnr = vim.api.nvim_get_current_buf()

for _, client in ipairs(clients) do

if client.server_capabilities.workspace then

local workspace = client.workspace_folders

local paths = workspace and vim.tbl_map(function(ws)

return vim.uri_to_fname(ws.uri)

end, workspace) or client.config.root_dir and { client.config.root_dir } or {}

for _, p in ipairs(paths) do

if vim.fn.match(vim.api.nvim_buf_get_name(bufnr), p) ~= -1 then

return p

end

end

end

end

-- Fallback to checking for common project markers

local markers = { ".git", "Makefile", "package.json", "go.mod", "Cargo.toml", "pyproject.toml" }

local path = vim.api.nvim_buf_get_name(bufnr)

local dirname = vim.fn.fnamemodify(path, ":p:h")

local function has_marker_file(dir, marker)

return vim.fn.filereadable(dir .. "/" .. marker) == 1 or

vim.fn.isdirectory(dir .. "/" .. marker) == 1

end

local function find_root(dir)

for _, marker in ipairs(markers) do

if has_marker_file(dir, marker) then

return dir

end

end

local parent = vim.fn.fnamemodify(dir, ":h")

if parent ~= dir then

return find_root(parent)

end

return nil

end

local root = find_root(dirname)

return root or vim.fn.getcwd()

end

-- Check if a path exists

---@param path string The path to check

---@return boolean exists Whether the path exists

function M.path_exists(path)

return vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1

end

-- Create a path if it doesn't exist

---@param path string The path to create

---@return boolean success Whether the path was created or already exists

function M.ensure_path(path)

if M.path_exists(path) then

return true

end

return vim.fn.mkdir(path, "p") == 1

end

-- Table utility functions

M.tbl = {}

-- Merge tables recursively

---@param t1 table First table

---@param t2 table Second table (has priority)

---@return table merged The merged table

function M.tbl.merge(t1, t2)

local result = vim.deepcopy(t1)

for k, v in pairs(t2) do

if type(v) == "table" and type(result[k]) == "table" then

result[k] = M.tbl.merge(result[k], v)

else

result[k] = v

end

end

return result

end

-- String utility functions

M.str = {}

-- Check if a string starts with a prefix

---@param str string The string to check

---@param prefix string The prefix to check for

---@return boolean starts_with Whether the string starts with the prefix

function M.str.starts_with(str, prefix)

return string.sub(str, 1, string.len(prefix)) == prefix

end

-- Check if a string ends with a suffix

---@param str string The string to check

---@param suffix string The suffix to check for

---@return boolean ends_with Whether the string ends with the suffix

function M.str.ends_with(str, suffix)

return suffix == "" or string.sub(str, -string.len(suffix)) == suffix

end

-- Create terminal toggle functions

M.term = {}

-- Factory for creating terminal toggle functions

---@param cmd string The command to run in the terminal

---@param direction string The direction to open the terminal in ("float", "horizontal", "vertical")

---@param count number The terminal count (optional, defaults to 1)

---@return function toggle_func The toggle function

function M.term.create_toggle(cmd, direction, count)

count = count or 1

return function()

-- Check if toggleterm is available

local Terminal = require("toggleterm.terminal").Terminal

local opts = {

cmd = cmd,

direction = direction,

count = count,

hidden = true,

on_open = function(term)

vim.cmd("startinsert!")

-- Set terminal-specific keymaps here if needed

end,

}

-- Add float options if using float mode

if direction == "float" then

opts.float_opts = {

border = "curved",

winblend = 0,

}

end

local term = Terminal:new(opts)

term:toggle()

end

end

-- Create common terminal toggles

M.term.toggles = {

-- Initialize with some common terminals

python = M.term.create_toggle("python", "float", 100),

node = M.term.create_toggle("node", "float", 101),

lazygit = M.term.create_toggle("lazygit", "float", 102),

htop = M.term.create_toggle("htop", "float", 103),

btm = M.term.create_toggle("btm", "float", 104), -- Bottom process viewer

ncdu = M.term.create_toggle("ncdu", "float", 105), -- Disk usage analyzer

}

-- LSP utilities

M.lsp = {}

-- Format the current buffer if formatting is available

---@param opts? table Options for formatting

function M.lsp.format(opts)

opts = opts or { async = false }

local bufnr = vim.api.nvim_get_current_buf()

local clients = vim.lsp.buf_get_clients(bufnr)

local can_format = false

for _, client in pairs(clients) do

if client.server_capabilities.documentFormattingProvider then

can_format = true

break

end

end

if can_format then

vim.lsp.buf.format(vim.tbl_extend("force", {

bufnr = bufnr,

-- filter = function(client)

-- return client.name ~= "tsserver" -- prefer other formatters over tsserver

-- end,

}, opts))

M.notify("Buffer formatted", "info", { title = "LSP Format" })

else

M.notify("No formatter available for this buffer", "warn", { title = "LSP Format" })

end

end

-- Create a light theme toggle

---@param dark_theme string The dark theme name

---@param light_theme string The light theme name

---@return function toggle_func The theme toggle function

function M.create_theme_toggle(dark_theme, light_theme)

return function()

local current = vim.g.colors_name

if current == dark_theme then

vim.cmd("colorscheme " .. light_theme)

M.notify("Light theme enabled: " .. light_theme, "info", { title = "Theme" })

else

vim.cmd("colorscheme " .. dark_theme)

M.notify("Dark theme enabled: " .. dark_theme, "info", { title = "Theme" })

end

end

end

-- Detect and adapt to system dark/light mode

function M.sync_theme_with_system()

-- This is a placeholder that needs system-specific implementation

-- Mac: use `defaults read -g AppleInterfaceStyle`

-- Linux: check gsettings or system files

-- Example for Linux (using gsettings)

local system_mode = vim.fn.system("gsettings get org.gnome.desktop.interface color-scheme"):match("prefer%-(%a+)")

if system_mode == "dark" then

vim.cmd("colorscheme tokyonight-night")

else

vim.cmd("colorscheme tokyonight-day")

end

end

-- Return the utilities module

return M
