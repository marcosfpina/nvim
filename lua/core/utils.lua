-- ~/.config/nvim/lua/core/utils.lua
-- Utility functions used throughout the configuration

local M = {}

-- Notification function with better defaults
M.notify = function(msg, level, opts)
  opts = opts or {}
  level = level or vim.log.levels.INFO
  vim.notify(msg, level, opts)
end

-- Check if a plugin is available
M.is_available = function(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.spec.plugins[plugin] ~= nil
end

-- Check if an LSP server is active
M.lsp_get_active_client_by_name = function(bufnr, name)
  for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client.name == name then
      return client
    end
  end
  return nil
end

-- Safe require with error handling
M.safe_require = function(module)
  local ok, result = pcall(require, module)
  if not ok then
    M.notify("Failed to load module: " .. module, vim.log.levels.ERROR)
    return nil
  end
  return result
end

-- Check if we're in a git repository
M.is_git_repo = function()
  local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:match("true") ~= nil
  end
  return false
end

-- Get project root directory
M.get_root = function()
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  local patterns = { ".git", "package.json", "Cargo.toml", "go.mod", "pyproject.toml", "setup.py" }
  
  local root = path and vim.fs.find(patterns, { path = path, upward = true })[1]
  root = root and vim.fn.fnamemodify(root, ":h") or vim.loop.cwd()
  return root
end

-- Create an augroup with clear
M.augroup = function(name)
  return vim.api.nvim_create_augroup("neovim_" .. name, { clear = true })
end

-- Format on save function
M.format_on_save = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  
  local ft = vim.bo[bufnr].filetype
  local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

  vim.lsp.buf.format({
    bufnr = bufnr,
    filter = function(client)
      if have_nls then
        return client.name == "null-ls"
      end
      return client.name ~= "null-ls"
    end,
  })
end

-- Toggle line numbers
M.toggle_number = function()
  if vim.wo.number then
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
  end
end

-- Toggle diagnostics
M.toggle_diagnostics = function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    M.notify("Diagnostics enabled", vim.log.levels.INFO)
  else
    vim.diagnostic.disable()
    M.notify("Diagnostics disabled", vim.log.levels.INFO)
  end
end

-- Get icon from nvim-web-devicons
M.get_icon = function(filename, ext)
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if ok then
    return devicons.get_icon(filename, ext, { default = true })
  end
  return ""
end

-- Merge tables
M.merge = function(...)
  local result = {}
  for _, tbl in ipairs({ ... }) do
    for k, v in pairs(tbl) do
      result[k] = v
    end
  end
  return result
end

-- Check if buffer is empty
M.is_empty_buffer = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return vim.api.nvim_buf_line_count(bufnr) == 1 
    and vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1] == ""
end

return M
