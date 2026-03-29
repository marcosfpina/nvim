-- ~/.config/nvim/lua/core/autocmds.lua
-- Core autocommands and autogroups

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Helper Functions                       │
-- ╰─────────────────────────────────────────────────────────╯

local create_augroup = function(name)
  return vim.api.nvim_create_augroup("nixvim_" .. name, { clear = true })
end

local autocmd = function(group, event, pattern, callback, desc)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = callback,
    desc = desc
  })
end

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Editor Behavior                        │
-- ╰─────────────────────────────────────────────────────────╯

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
    pcall(vim.api.nvim_win_set_cursor, 0, mark)
  end
end, "Return to last edit position")

-- Remove trailing whitespace on save
autocmd(editor_behavior, "BufWritePre", "*", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filesize = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
  local ignore_ft = { "diff", "gitcommit", "unite", "qf", "help" }
  
  if vim.bo.binary or filesize > 1024 * 1024 or vim.tbl_contains(ignore_ft, vim.bo.filetype) then
    return
  end
  
  local save = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.fn.winrestview(save)
end, "Remove trailing whitespace on save")

-- Don't autocomment new lines
autocmd(editor_behavior, "BufEnter", "*", function()
  vim.opt.formatoptions:remove({ "c", "r", "o" })
end, "Disable autocommenting new lines")

-- Override file detection for common patterns
autocmd(editor_behavior, { "BufRead", "BufNewFile" }, "*.md", function()
  vim.bo.filetype = "markdown"
end, "Set markdown filetype for .md files")

-- Resize splits on window resize
autocmd(editor_behavior, "VimResized", "*", function()
  vim.cmd("tabdo wincmd =")
end, "Resize splits when window is resized")

-- Check if file changed on disk and reload
autocmd(editor_behavior, { "FocusGained", "BufEnter" }, "*", function()
  if not vim.bo.readonly and vim.fn.bufname() ~= "" and vim.bo.buftype == "" then
    vim.cmd("checktime")
  end
end, "Check if file changed on disk")

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Terminal Behavior                      │
-- ╰─────────────────────────────────────────────────────────╯

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
  if vim.v.event.status == 0 then
    vim.api.nvim_buf_delete(vim.fn.expand("<abuf>"), { force = true })
  end
end, "Auto-close terminal buffer on clean exit")

-- ╭─────────────────────────────────────────────────────────╮
-- │                   LSP and Diagnostics                    │
-- ╰─────────────────────────────────────────────────────────╯

local lsp_behavior = create_augroup("lsp_behavior")

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Performance Optimizations              │
-- ╰─────────────────────────────────────────────────────────╯

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
      
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.foldenable = false
      vim.opt_local.cursorline = false
      vim.opt_local.swapfile = false
    end
  end
end, "Disable syntax highlighting for large files")

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Filetype-Specific Settings             │
-- ╰─────────────────────────────────────────────────────────╯

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
  vim.opt_local.spell = false
  vim.opt_local.conceallevel = 0
  vim.opt_local.colorcolumn = ""
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
  local ok, ufo = pcall(require, "ufo")
  if ok and ufo then
    vim.cmd("UfoAttach")
  end
end, "Initialize folding with nvim-ufo when available")

-- ╭─────────────────────────────────────────────────────────╮
-- │                   UI Refinements                         │
-- ╰─────────────────────────────────────────────────────────╯

local ui_refinements = create_augroup("ui_refinements")

-- Apply TokyoNight customizations after colorscheme loads
autocmd(ui_refinements, "ColorScheme", "tokyonight*", function()
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

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Session Management                     │
-- ╰─────────────────────────────────────────────────────────╯

local session_mgmt = create_augroup("session_mgmt")

-- Auto save session
autocmd(session_mgmt, "VimLeavePre", "*", function()
  if vim.fn.getcwd() ~= vim.fn.expand("~") and vim.fn.filereadable(".git/config") == 1 then
    if vim.fn.exists(":SessionSave") ~= 0 then
      vim.cmd("SessionSave")
    end
  end
end, "Auto save session for git repositories")
