-- ~/.config/nvim/lua/core/options.lua

-- Core Neovim settings and options

-- Python provider setup

vim.g.python3_host_prog = vim.fn.expand("~/.venvs/nvim/bin/python")

-- Disable unused providers

local disabled_providers = {

"node",

"perl",

"ruby",

}

for _, provider in ipairs(disabled_providers) do

vim.g["loaded_" .. provider .. "_provider"] = 0

end

-- UI settings

local opt = vim.opt

-- Appearance

opt.number = true -- Show line numbers

opt.relativenumber = true -- Show relative line numbers

opt.termguicolors = true -- Enable true color support

opt.cursorline = true -- Highlight current line

opt.signcolumn = "yes" -- Always show sign column

opt.showmode = false -- Don't show mode (statusline handles this)

opt.title = true -- Set terminal title

opt.wrap = false -- Don't wrap lines

opt.fillchars = {

horiz = "━",

horizup = "┻",

horizdown = "┳",

vert = "┃",

vertleft = "┫",

vertright = "┣",

verthoriz = "╋",

fold = " ",

eob = " ", -- No ~ for empty lines

diff = "╱", -- Diagonal lines for diff

msgsep = "‾",

}

opt.list = true -- Show some invisible characters

opt.listchars = {

tab = "→ ",

trail = "·",

nbsp = "␣",

extends = "⟩",

precedes = "⟨",

}

-- Scrolling and spacing

opt.scrolloff = 10 -- Keep 10 lines above/below cursor

opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor

opt.pumheight = 12 -- Maximum number of items in completion menu

opt.pumblend = 10 -- Slight transparency for popup menu

opt.winblend = 10 -- Slight transparency for floating windows

-- Tab/indent settings

opt.tabstop = 2 -- 2 spaces for tabs

opt.shiftwidth = 2 -- 2 spaces for indentation

opt.expandtab = true -- Use spaces instead of tabs

opt.smartindent = true -- Smart auto-indenting

opt.breakindent = true -- Indent wrapped lines

opt.linebreak = true -- Break at word boundaries

-- Search settings

opt.ignorecase = true -- Ignore case in search patterns

opt.smartcase = true -- Override ignorecase if pattern has uppercase

opt.hlsearch = true -- Highlight search results

opt.incsearch = true -- Show search matches as you type

opt.inccommand = "split" -- Preview substitutions live

-- File handling

opt.backup = false -- Don't create backup files

opt.swapfile = false -- Don't create swap files

opt.undofile = true -- Enable persistent undo

opt.undolevels = 10000 -- Maximum number of undo changes

opt.fileencoding = "utf-8" -- Use UTF-8 encoding

opt.hidden = true -- Allow switching buffers without saving

-- Timing and system

opt.updatetime = 100 -- Faster CursorHold events, better UX

opt.timeoutlen = 300 -- Time to wait for mapped sequences

opt.ttimeoutlen = 10 -- Time to wait for key codes

opt.redrawtime = 1500 -- Maximum time spent redrawing

opt.lazyredraw = true -- Don't redraw during macros

-- Completion

opt.completeopt = {

"menu",

"menuone",

"noselect",

} -- Better completion experience

opt.wildmode = "longest:full,full" -- Command-line completion mode

opt.wildignorecase = true -- Ignore case when completing file names

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

-- Splitting and windows

opt.splitbelow = true -- Split below current window

opt.splitright = true -- Split right of current window

opt.equalalways = false -- Don't resize windows on split/close

-- Mouse and clipboard

opt.mouse = "a" -- Enable mouse in all modes

opt.clipboard = "unnamedplus" -- Use system clipboard

-- Folding settings (improved with nvim-ufo later)

opt.foldlevel = 99 -- Default to all folds open

opt.foldlevelstart = 99 -- Start with all folds open

opt.foldenable = true -- Enable folding

-- Security and spellcheck

opt.modeline = false -- Disable modeline for security

opt.secure = true -- Restrict access in exrc files

opt.spelllang = "en_us" -- Spellcheck language

-- Performance and diffing

opt.synmaxcol = 240 -- Only highlight first 240 columns

opt.diffopt = {

"internal",

"filler",

"closeoff",

"vertical",

"algorithm:patience",

"indent-heuristic",

}

-- Shortmess settings to avoid unnecessary prompts

opt.shortmess:append({

c = true, -- Don't show ins-completion-menu messages

I = true, -- Don't show intro message

W = true, -- Don't show "written" for file writes

a = true, -- Use abbreviations in messages

F = true, -- Don't show file info when editing

})

-- Disable builtin plugins we don't need for better startup time

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

-- Set up filetype detection

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

[".*%.conf"] = "conf"

},

})

-- Set up custom highlighting

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

end

})
