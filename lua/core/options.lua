-- ~/.config/nvim/lua/core/options.lua
-- Core Neovim settings and options

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Python Provider Setup                  │
-- ╰─────────────────────────────────────────────────────────╯

local python_venv = vim.fn.expand("~/.venvs/nvim/bin/python")
if vim.fn.filereadable(python_venv) == 1 then
  vim.g.python3_host_prog = python_venv
else
  local python3_path = vim.fn.exepath("python3")
  if python3_path ~= "" then
    vim.g.python3_host_prog = python3_path
  end
end

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Disable Unused Providers               │
-- ╰─────────────────────────────────────────────────────────╯

local disabled_providers = { "node", "perl", "ruby" }

for _, provider in ipairs(disabled_providers) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- ╭─────────────────────────────────────────────────────────╮
-- │                   UI Settings                            │
-- ╰─────────────────────────────────────────────────────────╯

local opt = vim.opt

-- Appearance
opt.number = true                 -- Show line numbers
opt.relativenumber = true         -- Show relative line numbers
opt.termguicolors = true          -- Enable true color support
opt.cursorline = true             -- Highlight current line
opt.signcolumn = "yes"            -- Always show sign column
opt.showmode = false              -- Don't show mode (statusline handles this)
opt.title = true                  -- Set terminal title
opt.wrap = false                  -- Don't wrap lines
opt.laststatus = 3                -- One global statusline keeps the layout calmer
opt.cmdheight = 0                 -- Hide idle command line noise when possible
opt.showtabline = 1               -- Only show tabline when it adds value

opt.fillchars = {
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vert = "│",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
  fold = " ",
  eob = " ",                      -- No ~ for empty lines
  diff = "╱",                     -- Diagonal lines for diff
  msgsep = " ",
}

opt.list = false                  -- Keep invisible characters out of the way by default
opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  extends = "⟩",
  precedes = "⟨",
}

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Scrolling and Spacing                  │
-- ╰─────────────────────────────────────────────────────────╯

opt.scrolloff = 6                 -- Keep context without wasting too much space
opt.sidescrolloff = 4             -- Keep a bit of horizontal context
opt.pumheight = 10                -- Tighter completion menu
opt.pumblend = 0                  -- Opaque popups are easier to read
opt.winblend = 0                  -- Opaque floating windows improve contrast

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Tab/Indent Settings                    │
-- ╰─────────────────────────────────────────────────────────╯

opt.tabstop = 2                   -- 2 spaces for tabs
opt.shiftwidth = 2                -- 2 spaces for indentation
opt.expandtab = true              -- Use spaces instead of tabs
opt.smartindent = true            -- Smart auto-indenting
opt.breakindent = true            -- Indent wrapped lines
opt.linebreak = true              -- Break at word boundaries

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Search Settings                        │
-- ╰─────────────────────────────────────────────────────────╯

opt.ignorecase = true             -- Ignore case in search patterns
opt.smartcase = true              -- Override ignorecase if pattern has uppercase
opt.hlsearch = false              -- Don't leave search highlights hanging around
opt.incsearch = true              -- Show search matches as you type
opt.inccommand = "nosplit"        -- Preview substitutions without opening extra splits

-- ╭─────────────────────────────────────────────────────────╮
-- │                   File Handling                          │
-- ╰─────────────────────────────────────────────────────────╯

opt.backup = false                -- Don't create backup files
opt.swapfile = false              -- Don't create swap files
opt.undofile = true               -- Enable persistent undo
opt.undolevels = 10000            -- Maximum number of undo changes
opt.fileencoding = "utf-8"        -- Use UTF-8 encoding
opt.hidden = true                 -- Allow switching buffers without saving

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Timing and System                      │
-- ╰─────────────────────────────────────────────────────────╯

opt.updatetime = 250              -- Reduce idle event churn without feeling sluggish
opt.timeoutlen = 300              -- Time to wait for mapped sequences
opt.ttimeoutlen = 10              -- Time to wait for key codes
opt.redrawtime = 1500             -- Maximum time spent redrawing
opt.lazyredraw = false            -- Disabled for noice.nvim compatibility

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Completion                             │
-- ╰─────────────────────────────────────────────────────────╯

opt.completeopt = {
  "menu",
  "menuone",
  "noselect",
}                                 -- Better completion experience

opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.wildignorecase = true         -- Ignore case when completing file names

opt.wildignore = {
  "**/.git/*",
  "**/.hg/*",
  "**/.svn/*",
  "**/node_modules/*",
  "**/__pycache__/*",
  "**/venv/*",
  "**/.pytest_cache/*",
  "**/target/*",
  "**/dist/*",
  "**/build/*",
  "*.o",
  "*.obj",
  "*.bin",
}

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Splitting and Windows                  │
-- ╰─────────────────────────────────────────────────────────╯

opt.splitbelow = true             -- Split below current window
opt.splitright = true             -- Split right of current window
opt.equalalways = false           -- Don't resize windows on split/close

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Mouse and Clipboard                    │
-- ╰─────────────────────────────────────────────────────────╯

opt.mouse = "a"                   -- Enable mouse in all modes
opt.clipboard = "unnamedplus"     -- Use system clipboard

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Folding Settings                       │
-- ╰─────────────────────────────────────────────────────────╯

opt.foldlevel = 99                -- Default to all folds open
opt.foldlevelstart = 99           -- Start with all folds open
opt.foldenable = true             -- Enable folding

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Security and Spellcheck                │
-- ╰─────────────────────────────────────────────────────────╯

opt.modeline = false              -- Disable modeline for security
opt.secure = true                 -- Restrict access in exrc files
opt.spelllang = "en_us"           -- Spellcheck language
opt.spell = false                 -- No spell highlights unless explicitly enabled

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Performance and Diffing                │
-- ╰─────────────────────────────────────────────────────────╯

opt.synmaxcol = 240               -- Only highlight first 240 columns

opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "vertical",
  "algorithm:patience",
  "indent-heuristic",
}

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Shortmess Settings                     │
-- ╰─────────────────────────────────────────────────────────╯

opt.shortmess:append({
  c = true,                       -- Don't show ins-completion-menu messages
  I = true,                       -- Don't show intro message
  W = true,                       -- Don't show "written" for file writes
  a = true,                       -- Use abbreviations in messages
  F = true,                       -- Don't show file info when editing
})

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Disable Builtin Plugins                │
-- ╰─────────────────────────────────────────────────────────╯

local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
  "matchparen",
  "tutor",
  "rplugin",
  "tohtml",
  "man",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Filetype Detection                     │
-- ╰─────────────────────────────────────────────────────────╯

vim.filetype.add({
  extension = {
    mdx = "markdown.mdx",
    zsh = "zsh",
  },
  filename = {
    [".eslintrc"] = "json",
    [".prettierrc"] = "json",
    [".babelrc"] = "json",
    ["tsconfig.json"] = "jsonc",
    ["Dockerfile.*"] = "dockerfile",
  },
  pattern = {
    [".*%.env%..*"] = "sh",
    [".*%.conf"] = "conf",
  },
})

-- ╭─────────────────────────────────────────────────────────╮
-- │                   Custom Highlighting                    │
-- ╰─────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- Custom highlights that apply to any colorscheme
    vim.api.nvim_set_hl(0, "WinSeparator", { link = "LineNr" })
    
    -- Improve the appearance of diagnostic virtual text
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticWarn" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticInfo" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "DiagnosticHint" })
    
    -- Better fold highlighting
    vim.api.nvim_set_hl(0, "Folded", { fg = "#7aa2f7", bg = "NONE" })
  end,
})
