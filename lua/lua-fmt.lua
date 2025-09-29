-- Quick Lua line formatter (similar to nix fmt)
-- Formats Lua code lines for better readability, especially for plugin configs

local M = {}

-- Format a single line of Lua code
function M.format_line(line)
  if not line or line == "" then return line end

  -- Remove extra spaces around operators
  line = line:gsub("%s*=%s*", " = ")
  line = line:gsub("%s*,%s*", ", ")
  line = line:gsub("%s*{%s*", "{ ")
  line = line:gsub("%s*}%s*", " }")
  line = line:gsub("%s*%(%s*", "(")
  line = line:gsub("%s*%)%s*", ")")

  -- Fix string quotes consistency (prefer double quotes)
  line = line:gsub("'([^']*)'", '"%1"')

  -- Format plugin-style key-value pairs
  line = line:gsub('(%w+)%s*=%s*"([^"]*)"', '%1 = "%2"')
  line = line:gsub('(%w+)%s*=%s*(%d+)', '%1 = %2')
  line = line:gsub('(%w+)%s*=%s*(true|false)', '%1 = %2')

  -- Clean up multiple spaces
  line = line:gsub("%s+", " ")
  line = line:gsub("^%s+", "")  -- trim leading
  line = line:gsub("%s+$", "")  -- trim trailing

  return line
end

-- Format current line in buffer
function M.format_current_line()
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  local formatted = M.format_line(line)

  if formatted ~= line then
    vim.api.nvim_set_current_line(formatted)
    vim.notify("Line formatted", vim.log.levels.INFO, { title = "Lua Formatter" })
  end
end

-- Format visual selection
function M.format_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = start_pos[2]
  local end_line = end_pos[2]

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local formatted_lines = {}

  for _, line in ipairs(lines) do
    table.insert(formatted_lines, M.format_line(line))
  end

  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, formatted_lines)
  vim.notify(string.format("Formatted %d lines", #formatted_lines), vim.log.levels.INFO, { title = "Lua Formatter" })
end

-- Format entire buffer (with confirmation)
function M.format_buffer()
  vim.ui.input({
    prompt = "Format entire buffer? (y/N): ",
  }, function(input)
    if input and input:lower() == "y" then
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local formatted_lines = {}

      for _, line in ipairs(lines) do
        table.insert(formatted_lines, M.format_line(line))
      end

      vim.api.nvim_buf_set_lines(0, 0, -1, false, formatted_lines)
      vim.notify(string.format("Formatted %d lines", #formatted_lines), vim.log.levels.INFO, { title = "Lua Formatter" })
    end
  end)
end

-- Advanced formatting for plugin configurations
function M.format_plugin_config()
  local line = vim.api.nvim_get_current_line()

  -- Special handling for plugin specs
  if line:match("^%s*{") then
    -- Format plugin table opening
    line = line:gsub("^(%s*){", '%1{')
  elseif line:match('^%s*"[^"]+",?') then
    -- Format plugin names
    line = line:gsub('^(%s*)"([^"]+)"(,?)', '%1"%2"%3')
  elseif line:match("opts%s*=") then
    -- Format opts assignments
    line = line:gsub("opts%s*=%s*{", "opts = {")
  elseif line:match("config%s*=") then
    -- Format config assignments
    line = line:gsub("config%s*=%s*function", "config = function")
  end

  -- Apply general formatting
  line = M.format_line(line)

  vim.api.nvim_set_current_line(line)
end

-- Smart indentation for Lua tables
function M.smart_indent_table()
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  local indent = line:match("^%s*") or ""

  -- If line ends with {, add proper indentation for next line
  if line:match("{%s*$") then
    local new_line = indent .. "  "
    vim.api.nvim_put({""}, "l", true, true)
    vim.api.nvim_set_current_line(new_line)
    vim.cmd("startinsert!")
  end
end

-- Quick format for common Lua patterns
function M.quick_patterns()
  local patterns = {
    -- Convert single quotes to double quotes
    { pattern = "'([^']*)'", replacement = '"%1"' },
    -- Fix spacing around equals
    { pattern = "(%w+)%s*=%s*(.+)", replacement = "%1 = %2" },
    -- Fix table brackets
    { pattern = "{%s*(.-)%s*}", replacement = "{ %1 }" },
    -- Fix function calls
    { pattern = "(%w+)%s*%(%s*(.-)%s*%)", replacement = "%1(%2)" },
  }

  local line = vim.api.nvim_get_current_line()
  local original = line

  for _, p in ipairs(patterns) do
    line = line:gsub(p.pattern, p.replacement)
  end

  if line ~= original then
    vim.api.nvim_set_current_line(line)
    vim.notify("Quick format applied", vim.log.levels.INFO, { title = "Lua Formatter" })
  end
end

-- Create user commands for the formatter
vim.api.nvim_create_user_command("LuaFmtLine", M.format_current_line, { desc = "Format current Lua line" })
vim.api.nvim_create_user_command("LuaFmtBuffer", M.format_buffer, { desc = "Format entire Lua buffer" })
vim.api.nvim_create_user_command("LuaFmtPlugin", M.format_plugin_config, { desc = "Format plugin configuration" })
vim.api.nvim_create_user_command("LuaFmtQuick", M.quick_patterns, { desc = "Apply quick format patterns" })

return M