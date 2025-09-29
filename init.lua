--[[

███╗ ██╗███████╗ ██████╗ ██╗ ██╗██╗███╗ ███╗

████╗ ██║██╔════╝██╔═══██╗██║ ██║██║████╗ ████║

██╔██╗ ██║█████╗ ██║ ██║██║ ██║██║██╔████╔██║

██║╚██╗██║██╔══╝ ██║ ██║╚██╗ ██╔╝██║██║╚██╔╝██║

██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║

╚═╝ ╚═══╝╚══════╝ ╚═════╝ ╚═══╝ ╚═╝╚═╝ ╚═╝

Neovim Configuration for Linux Mint with Alacritty terminal

Optimized for Development in 2025

Author: Advanced Neovim User

Repository: https://github.com/yourusername/dotfiles

Last updated: 2025

--]]

--------------------------------------------------------------------------------

-- CORE SETTINGS

--------------------------------------------------------------------------------

-- Initialize globals and leader keys

vim.g.mapleader = " "

vim.g.maplocalleader = ","

-- Load core modules

require("core.options")

require("core.keymaps")

--require("core.autocmds")

--require("core.lazy") -- Plugin manager setup

-- Initialize any global utilities

_G.utils = require("core.utils")

-- Finally require all plugin configurations

require("plugins")

