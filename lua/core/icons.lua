-- ~/.config/nvim/lua/core/icons.lua
-- Icons used throughout the configuration

local M = {}

M.diagnostics = {
  Error = "",
  Warn = "",
  Hint = "",
  Info = "",
}

M.git = {
  Added = "",
  Modified = "",
  Removed = "",
  Staged = "",
  Renamed = "",
  Untracked = "",
  Ignored = "",
  Unstaged = "",
  Conflict = "",
  Unmerged = "",
}

M.kinds = {
  Array = "",
  Boolean = "",
  Class = "",
  Color = "",
  Constant = "",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Key = "",
  Keyword = "",
  Method = "",
  Module = "",
  Namespace = "",
  Null = "ﳠ",
  Number = "",
  Object = "",
  Operator = "",
  Package = "",
  Property = "",
  Reference = "",
  Snippet = "",
  String = "",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "",
}

M.documents = {
  File = "",
  Files = "",
  Folder = "",
  OpenFolder = "",
}

M.ui = {
  ArrowClosed = "",
  ArrowOpen = "",
  Lock = "",
  Circle = "",
  BigCircle = "",
  BigUnfilledCircle = "",
  Close = "",
  NewFile = "",
  Search = "",
  Glass = "",
  Table = "",
  Calendar = "",
  Lightbulb = "",
}

M.misc = {
  Robot = "ﮧ",
  Squirrel = "",
  Tag = "",
  Watch = "",
  Smiley = "",
  Package = "",
  CircuitBoard = "",
}

M.dap = {
  Breakpoint = "",
  BreakpointRejected = "",
  BreakpointCondition = "",
  LogPoint = "",
  Pause = "",
  Play = "",
  StepInto = "",
  StepOut = "",
  StepOver = "",
  Terminate = "",
  Restart = "",
}

M.lsp = {
  server_installed = "✓",
  server_pending = "➜",
  server_uninstalled = "✗",
}

M.separators = {
  dot_left = "",
  dot_right = "",
  arrow_left = "",
  arrow_right = "",
  slant_left = "",
  slant_right = "",
  rounded_left = "",
  rounded_right = "",
  block_left = "█",
  block_right = "█",
}

M.todo = {
  fix = "",
  todo = "",
  hack = "",
  warn = "",
  perf = "",
  note = "",
  test = "⏲",
}

return M
