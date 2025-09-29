local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Navigation Chaos
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts)

-- LSP Chaos Control
keymap("n", "gd", vim.lsp.buf.definition, opts)
keymap("n", "gD", vim.lsp.buf.declaration, opts)
keymap("n", "gi", vim.lsp.buf.implementation, opts)
keymap("n", "gr", vim.lsp.buf.references, opts)
keymap("n", "K", vim.lsp.buf.hover, opts)
keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)

-- Terminal Chaos
keymap("n", "<leader>tt", ":ToggleTerm<CR>", opts)
keymap("n", "<leader>tg", ":ToggleTerm direction=float<CR>", opts)
keymap("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>", opts)
keymap("n", "<leader>tv", ":ToggleTerm direction=vertical<CR>", opts)

-- Git Chaos
keymap("n", "<leader>gb", ":Gitsigns blame_line<CR>", opts)
keymap("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", opts)
keymap("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", opts)
keymap("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", opts)

-- 🔥 CHAOS AUTOCOMMANDS
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Auto-save chaos control
augroup("ChaosAutoSave", { clear = true })
autocmd({ "InsertLeave", "TextChanged" }, {
  group = "ChaosAutoSave",
  pattern = "*",
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" then
      vim.cmd("silent! write")
    end
  end,
})

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- 🎮 CHAOS STATUS LINE
vim.o.statusline = table.concat({
  "%#ChaosMode# CHAOS ",
  "%#Normal# %f ",
  "%m%r%h%w",
  "%=",
  "%#ChaosMode# %{&ft} ",
  "%#Normal# %l:%c ",
  "%#ChaosMode# %p%% ",
})

-- 🔐 SENSITIVE BLOCK: Final Settings
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo//")
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

print("🔥 TECH CAMARADA CONNECTION: ESTABLISHED!")
print("🎯 CHAOS CONTROL: ACTIVATED!")
print("🚀 TRIAL MODE: ENGAGED!")
