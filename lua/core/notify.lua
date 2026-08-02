-- Central notification guard for noisy repeated plugin messages.

local M = {}

local notify_impl = nil
local recent = {}

local noisy_patterns = {
  "treesitter",
  "tree%-sitter",
  "nvim%-treesitter",
  "no parser for",
  "parser not found",
  "parser.*not installed",
  "could not load parser",
}

local function message_to_string(msg)
  if type(msg) == "string" then
    return msg
  end

  local ok, inspected = pcall(vim.inspect, msg)
  if ok then
    return inspected
  end

  return tostring(msg)
end

local function should_skip(message, level)
  level = level or vim.log.levels.INFO

  if level >= vim.log.levels.ERROR then
    return false
  end

  local lower = message:lower()
  for _, pattern in ipairs(noisy_patterns) do
    if lower:find(pattern) then
      return true
    end
  end

  return false
end

function M.notify(msg, level, opts)
  local message = message_to_string(msg)
  level = level or vim.log.levels.INFO

  if should_skip(message, level) then
    return
  end

  local title = opts and opts.title or ""
  local key = table.concat({ tostring(level), title, message }, "\n")
  local now = vim.loop.now()
  local window = level >= vim.log.levels.ERROR and 2500 or 5000

  if recent[key] and now - recent[key] < window then
    return
  end
  recent[key] = now

  if type(notify_impl) == "function" and notify_impl ~= M.notify then
    return notify_impl(msg, level, opts)
  end

  return vim.api.nvim_echo({ { message } }, true, {})
end

function M.install()
  if vim.notify == M.notify then
    return
  end

  notify_impl = vim.notify
  vim.notify = M.notify
end

return M
