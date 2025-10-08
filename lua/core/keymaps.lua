-- ~/.config/nvim/lua/core/keymaps.lua

-- Core keymaps, independent of plugins

local map = vim.keymap.set

-- Helper function for generating key mappings with better descriptions

---@param mode string|table Mode where the mapping is active

---@param lhs string Left-hand side of the mapping

---@param rhs string|function Right-hand side of the mapping

---@param desc string Description of the mapping

local function mapd(mode, lhs, rhs, desc)

map(mode, lhs, rhs, { desc = desc, silent = true, noremap = true })

end

-- Core Vim movement and editing

---------------------------------------

-- Better window navigation

mapd("n", "<C-h>", "<C-w>h", "Move to left window")

mapd("n", "<C-j>", "<C-w>j", "Move to bottom window")

mapd("n", "<C-k>", "<C-w>k", "Move to top window")

mapd("n", "<C-l>", "<C-w>l", "Move to right window")

-- Resize windows with arrows

mapd("n", "<C-Up>", "<cmd>resize -2<CR>", "Decrease window height")

mapd("n", "<C-Down>", "<cmd>resize +2<CR>", "Increase window height")

mapd("n", "<C-Left>", "<cmd>vertical resize -2<CR>", "Decrease window width")

mapd("n", "<C-Right>", "<cmd>vertical resize +2<CR>", "Increase window width")

-- Navigate buffers

mapd("n", "<S-l>", "<cmd>bnext<CR>", "Next buffer")

mapd("n", "<S-h>", "<cmd>bprevious<CR>", "Previous buffer")

-- Clear highlights

mapd("n", "<leader>h", "<cmd>nohlsearch<CR>", "Clear highlights")

-- Close buffer

mapd("n", "<S-q>", function()

local bufnr = vim.api.nvim_get_current_buf()

local modified = vim.api.nvim_buf_get_option(bufnr, "modified")

if modified then

vim.ui.input({

prompt = "Buffer is modified. Save changes? (y/n/c): ",

}, function(input)

if input == "y" then

vim.cmd("write")

vim.cmd("bd")

elseif input == "n" then

vim.cmd("bd!")

end

-- 'c' or any other input cancels

end)

else

vim.cmd("bd")

end

end, "Close buffer")

-- Better paste - doesn't overwrite register when pasting over selection

mapd("v", "p", '"_dP', "Paste without overwriting register")

-- Visual mode indent keeps selection

mapd("v", "<", "<gv", "Indent left and maintain selection")

mapd("v", ">", ">gv", "Indent right and maintain selection")

-- Move text up and down

mapd("v", "J", ":m '>+1<CR>gv=gv", "Move text down")

mapd("v", "K", ":m '<-2<CR>gv=gv", "Move text up")

mapd("n", "<A-j>", "<cmd>m .+1<CR>==", "Move line down")

mapd("n", "<A-k>", "<cmd>m .-2<CR>==", "Move line up")

-- Move by display lines when wrapped, but count by real lines

mapd("n", "j", 'v:count ? "j" : "gj"', "Move down (display line)") -- Expression mapping

mapd("n", "k", 'v:count ? "k" : "gk"', "Move up (display line)") -- Expression mapping

-- Common operations

---------------------------------------

-- Save file

mapd("n", "<leader>w", "<cmd>w!<CR>", "Save file")

mapd("n", "<C-s>", "<cmd>w!<CR>", "Save file")

-- Quit

mapd("n", "<leader>q", "<cmd>q!<CR>", "Quit")

-- Select all

mapd("n", "<C-a>", "gg<S-v>G", "Select all")

-- Reload configuration

mapd("n", "<leader>r", function()

-- Clean Neovim's runtime path cache

vim.api.nvim_command("source " .. vim.env.MYVIMRC)

vim.notify("Config reloaded!", vim.log.levels.INFO, { title = "Neovim" })

end, "Reload init.lua")

-- Jump to start and end of line

mapd("n", "H", "^", "Jump to first non-blank character")

mapd("n", "L", "$", "Jump to end of line")

-- Better search with centered results

mapd("n", "n", "nzzzv", "Next search result (centered)")

mapd("n", "N", "Nzzzv", "Previous search result (centered)")

-- Maintain cursor position on join lines

mapd("n", "J", "mzJ`z", "Join lines without moving cursor")

-- Split lines (opposite of J)

mapd("n", "<leader>j", "i<CR><Esc>", "Split line")

-- Yank to system clipboard

mapd("n", "<leader>y", '"+y', "Yank to system clipboard")

mapd("v", "<leader>y", '"+y', "Yank to system clipboard")

-- Paste from system clipboard

mapd("n", "<leader>p", '"+p', "Paste from system clipboard")

mapd("v", "<leader>p", '"+p', "Paste from system clipboard")

-- Replaces the word under cursor

mapd("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", "Search/replace current word")

-- Format file

mapd("n", "<leader>lf", function()

vim.lsp.buf.format({ async = true })

end, "Format document")

-- Enhanced core functionality

---------------------------------------

-- Create new file

mapd("n", "<leader>fn", "<cmd>enew<CR>", "New file")

-- Increment/decrement numbers

mapd("n", "+", "<C-a>", "Increment number")

mapd("n", "-", "<C-x>", "Decrement number")

-- Center view on search and jumps

mapd("n", "<C-d>", "<C-d>zz", "Scroll down (centered)")

mapd("n", "<C-u>", "<C-u>zz", "Scroll up (centered)")

-- Switch between relative and absolute line numbers

mapd("n", "<leader>nl", function()

if vim.o.relativenumber then

vim.o.relativenumber = false

vim.notify("Absolute line numbers enabled", vim.log.levels.INFO)

else

vim.o.relativenumber = true

vim.notify("Relative line numbers enabled", vim.log.levels.INFO)

end

end, "Toggle relative line numbers")

-- Toggle spell checking

mapd("n", "<leader>ts", function()

vim.opt.spell = not vim.opt.spell:get()

if vim.opt.spell:get() then

vim.notify("Spell checking enabled", vim.log.levels.INFO)

else

vim.notify("Spell checking disabled", vim.log.levels.INFO)

end

end, "Toggle spell checking")

-- Navigate diagnostics

mapd("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")

mapd("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

mapd("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic in float")

mapd("n", "<leader>qd", vim.diagnostic.setloclist, "Diagnostics to location list")

-- Terminal integration

---------------------------------------

-- Better terminal mode navigation

map("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Move to left window", silent = true })

map("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Move to bottom window", silent = true })

map("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Move to top window", silent = true })

map("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Move to right window", silent = true })

map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode", silent = true })

map("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode", silent = true })

-- Create splits

mapd("n", "<leader>ws", "<cmd>split<CR>", "Split window horizontally")

mapd("n", "<leader>wv", "<cmd>vsplit<CR>", "Split window vertically")

mapd("n", "<leader>wq", "<cmd>q<CR>", "Close window")

mapd("n", "<leader>wm", "<cmd>MaximizerToggle<CR>", "Maximize window")

-- Lua Quick Formatter (like nix fmt)
---------------------------------------

local lua_fmt_ok, lua_fmt = pcall(require, "lua-fmt")

if lua_fmt_ok then
  mapd("n", "<leader>fl", lua_fmt.format_current_line, "Format current line (Lua)")
  mapd("v", "<leader>fl", lua_fmt.format_selection, "Format selection (Lua)")
  mapd("n", "<leader>fL", lua_fmt.format_buffer, "Format buffer (Lua)")
  mapd("n", "<leader>fp", lua_fmt.format_plugin_config, "Format plugin config")
  mapd("n", "<leader>fq", lua_fmt.quick_patterns, "Quick format patterns")
  mapd("n", "<leader>fi", lua_fmt.smart_indent_table, "Smart table indent")
else
  vim.notify("lua-fmt module not available, formatter keybindings disabled", vim.log.levels.WARN)
end

-- Register leader based mappings for which-key discovery later

-- These will be populated by which-key, but defined here for reference

vim.api.nvim_create_augroup("_mappings", { clear = true })

vim.api.nvim_create_autocmd("User", {

pattern = "LazyDone",

group = "_mappings",

callback = function()

-- Map namespace groups for WhichKey to discover

local ok, builtin_wk = pcall(require, "which-key")

if not ok then

vim.notify("which-key not available, skipping leader mappings", vim.log.levels.WARN)

return

end

-- Define base leader mappings

builtin_wk.register({

b = { name = "Buffers" },

c = { name = "Code" },

d = { name = "Debug" },

f = {
  name = "Find/Format",
  l = "Format line (Lua)",
  L = "Format buffer (Lua)",
  p = "Format plugin config",
  q = "Quick format patterns",
  i = "Smart table indent"
},

g = { name = "Git" },

l = { name = "LSP" },

n = { name = "Navigate" },

t = { name = "Terminal/Toggle" },

w = { name = "Window" },

x = { name = "Diagnostics" },

m = { name = "Markdown" },

o = { name = "Options" },

p = { name = "Projects" },

u = { name = "UI" },

}, { prefix = "<leader>" })

-- TODO: Add plugin specific leader mappings here or in their respective config files

end,

})
