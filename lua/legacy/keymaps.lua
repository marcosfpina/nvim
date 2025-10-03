local prefix_groups = {
  [" "]              = (ui_ic.Keyboard or "⌨")    .. " Main Actions",
  ["<leader>b"]     = (ui_ic.Tab or "󰓩")         .. " Buffers",
  ["<leader>c"]     = (icons.misc and icons.misc.Copilot or "") .. " Code/AI",
  ["<leader>d"]     = (icons.diagnostics and icons.diagnostics.Bug or "") .. " Debug/Diagnostics",
  ["<leader>e"]     = (ui_ic.FolderOpen or "") .. " Explorer",
  ["<leader>f"]     = (ui_ic.Search or "")     .. " Find/Files",
  ["<leader>g"]     = (icons.git and icons.git.Repo or "") .. " Git",
  ["<leader>l"]     = (icons.misc and icons.misc.LSP or "") .. " LSP",
  ["<leader>t"]     = (ui_ic.Terminal or "")    .. " Terminal",
  ["<leader>x"]     = (icons.diagnostics and icons.diagnostics.Warn or "") .. " Trouble/Extra",
  ["<leader>q"]     = (ui_ic.Exit or "")       .. " Quit/Session",
}
