-- ~/.config/nvim/lua/core/autocmds.lua

-- Core autocommands and autogroups

-- Create autocommand groups

local create_augroup = function(name)

return vim.api.nvim_create_augroup("nixvim_" .. name, { clear = true })

end

-- Create autocommands with a description

local autocmd = function(group, event, pattern, callback, desc)

vim.api.nvim_create_autocmd(event, {

group = group,

pattern = pattern,

callback = callback,

desc = desc

})

end

-- Editor behavior augroup

local editor_behavior = create_augroup("editor_behavior")

-- Highlight on yank

autocmd(editor_behavior, "TextYankPost", "*", function()

vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })

end, "Highlight yanked text")

-- Return to last edit position

autocmd(editor_behavior, "BufReadPost", "*", function()

local exclude = { "gitcommit", "gitrebase", "svn", "hgcommit" }

local buf = vim.api.nvim_get_current_buf()

if vim.tbl_contains(exclude, vim.bo[buf].filetype) then

return

end

local mark = vim.api.nvim_buf_get_mark(0, '"')

local line_count = vim.api.nvim_buf_line_count(0)

if mark[1] > 0 and mark[1] <= line_count then

-- Use pcall for safer cursor positioning

pcall(vim.api.nvim_win_set_cursor, 0, mark)

end

end, "Return to last edit position")

-- Remove trailing whitespace on save

autocmd(editor_behavior, "BufWritePre", "*", function()

-- Skip binary files, large files, or certain filetypes

local bufnr = vim.api.nvim_get_current_buf()

local filesize = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))

local ignore_ft = { "diff", "gitcommit", "unite", "qf", "help" }

if vim.bo.binary or filesize > 1024 * 1024 or vim.tbl_contains(ignore_ft, vim.bo.filetype) then

return

end

-- Save cursor position

local cursor_pos = vim.api.nvim_win_get_cursor(0)

-- Use a more specific pattern to avoid removing intentional trailing spaces

local save = vim.fn.winsaveview()

vim.cmd([[keeppatterns %s/\s\+$//e]])

vim.fn.winrestview(save)

end, "Remove trailing whitespace on save")

-- Don't autocomment new lines

autocmd(editor_behavior, "BufEnter", "*", function()

vim.opt.formatoptions:remove({ "c", "r", "o" })

end, "Disable autocommenting new lines")

-- Override file detection for common patterns

autocmd(editor_behavior, "BufRead,BufNewFile", "*.md", function()

vim.bo.filetype = "markdown"

end, "Set markdown filetype for .md files")

-- Resize splits on window resize

autocmd(editor_behavior, "VimResized", "*", function()

vim.cmd("tabdo wincmd =")

end, "Resize splits when window is resized")

-- Check if file changed on disk and reload

autocmd(editor_behavior, "FocusGained,BufEnter,CursorHold,CursorHoldI", "*", function()

if not vim.bo.readonly and vim.fn.bufname() ~= "" and vim.bo.buftype == "" then

vim.cmd("checktime")

end

end, "Check if file changed on disk")

-- Terminal behavior augroup

local term_behavior = create_augroup("term_behavior")

-- Set terminal-specific options

autocmd(term_behavior, "TermOpen", "*", function()

vim.opt_local.number = false

vim.opt_local.relativenumber = false

vim.opt_local.signcolumn = "no"

vim.cmd("startinsert!")

end, "Configure terminal appearance and start in insert mode")

-- Close terminal buffer on process exit

autocmd(term_behavior, "TermClose", "*", function()

-- Only auto-close if terminal exited cleanly

if vim.v.event.status == 0 then

vim.api.nvim_buf_delete(vim.fn.expand("<abuf>"), { force = true })

end

end, "Auto-close terminal buffer on clean exit")

-- LSP and diagnostics augroup

local lsp_behavior = create_augroup("lsp_behavior")

-- Show diagnostics on cursor hold

autocmd(lsp_behavior, "CursorHold", "*", function()

local opts = {

focusable = false,

close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },

source = "always",

prefix = " ",

scope = "cursor",

}

vim.diagnostic.open_float(nil, opts)

end, "Show diagnostic popup on cursor hold")

-- Format on save for supported filetypes

autocmd(lsp_behavior, "BufWritePre", "*.lua,*.py,*.js,*.jsx,*.ts,*.tsx,*.json,*.go,*.rs", function()

-- Skip formatting on large files

local bufnr = vim.api.nvim_get_current_buf()

local line_count = vim.api.nvim_buf_line_count(bufnr)

if line_count > 10000 then

vim.notify("File too large for auto-formatting", vim.log.levels.WARN)

return

end

-- Format if the client supports it

local clients = vim.lsp.buf_get_clients(bufnr)

local can_format = false

for _, client in pairs(clients) do

if client.server_capabilities.documentFormattingProvider then

can_format = true

break

end

end

if can_format then

vim.lsp.buf.format({

timeout_ms = 1000,

async = false,

})

end

end, "Format on save for supported filetypes")

-- Performance optimizations augroup

local performance = create_augroup("performance")

-- Disable syntax highlighting for large files

autocmd(performance, "BufReadPre", "*", function()

local max_filesize = 1 * 1024 * 1024 -- 1MB

local filename = vim.api.nvim_buf_get_name(0)

if filename ~= "" then

local stats = vim.loop.fs_stat(filename)

if stats and stats.size > max_filesize then

vim.cmd("syntax off")

vim.notify("File too large, syntax highlighting disabled", vim.log.levels.WARN)

-- Also disable other potentially slow features

vim.opt_local.foldmethod = "manual"

vim.opt_local.foldenable = false

vim.opt_local.cursorline = false

vim.opt_local.swapfile = false

end

end

end, "Disable syntax highlighting for large files")

-- Filetype-specific settings

local filetype_settings = create_augroup("filetype_settings")

-- Python files

autocmd(filetype_settings, "FileType", "python", function()

vim.opt_local.tabstop = 4

vim.opt_local.shiftwidth = 4

vim.opt_local.expandtab = true

vim.opt_local.foldmethod = "indent"

vim.opt_local.foldlevel = 99

end, "Python-specific settings")

-- Markdown files

autocmd(filetype_settings, "FileType", "markdown", function()

vim.opt_local.wrap = true

vim.opt_local.linebreak = true

vim.opt_local.spell = true

vim.opt_local.conceallevel = 2

end, "Markdown-specific settings")

-- Shell/bash/zsh files

autocmd(filetype_settings, "FileType", "sh,bash,zsh", function()

vim.opt_local.tabstop = 2

vim.opt_local.shiftwidth = 2

vim.opt_local.expandtab = true

end, "Shell script-specific settings")

-- JavaScript/TypeScript files

autocmd(filetype_settings, "FileType", "javascript,typescript,typescriptreact,javascriptreact", function()

vim.opt_local.tabstop = 2

vim.opt_local.shiftwidth = 2

vim.opt_local.expandtab = true

end, "JavaScript/TypeScript-specific settings")

-- YAML files

autocmd(filetype_settings, "FileType", "yaml,yml", function()

vim.opt_local.tabstop = 2

vim.opt_local.shiftwidth = 2

vim.opt_local.expandtab = true

end, "YAML-specific settings")

-- Docker files

autocmd(filetype_settings, "FileType", "dockerfile", function()

vim.opt_local.tabstop = 4

vim.opt_local.shiftwidth = 4

vim.opt_local.expandtab = true

end, "Dockerfile-specific settings")

-- Initialize folding for supported filetypes after loading

autocmd(filetype_settings, "FileType", "*", function()

if vim.fn.exists("loaded_ufo") ~= 0 then

-- Let nvim-ufo handle folding after plugin is loaded

vim.cmd("UfoAttach")

end

end, "Initialize folding with nvim-ufo when available")

-- UI refinements augroup

local ui_refinements = create_augroup("ui_refinements")

-- Auto-center insert mode

autocmd(ui_refinements, "InsertEnter", "*", function()

vim.cmd("norm zz")

end, "Center view when entering insert mode")

-- Apply TokyoNight customizations after colorscheme loads

autocmd(ui_refinements, "ColorScheme", "tokyonight*", function()

-- Custom highlight groups for better UI

local highlights = {

["@variable"] = { italic = true },

["@function"] = { bold = true },

["@keyword"] = { italic = true },

["@type"] = { bold = true },

}

for group, options in pairs(highlights) do

vim.api.nvim_set_hl(0, group, options)

end

end, "Apply TokyoNight customizations")

-- Session management augroup

local session_mgmt = create_augroup("session_mgmt")

-- Auto save session

autocmd(session_mgmt, "VimLeavePre", "*", function()

-- Only save session for real projects, not temp files

if vim.fn.getcwd() ~= vim.fn.expand("~") and vim.fn.filereadable(".git/config") == 1 then

-- Use session.nvim if available

if vim.fn.exists(":SessionSave") ~= 0 then

vim.cmd("SessionSave")

end

end

end, "Auto save session for git repositories")
