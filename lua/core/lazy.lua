-- ~/.config/nvim/lua/core/lazy.lua
-- Lazy.nvim plugin manager setup with NixOS compatibility

-- Detect NixOS environment
local is_nixos = vim.fn.executable("nix") == 1 or vim.env.NIX_PATH ~= nil

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is available before trying to use it
local lazy_available = false

-- Try to find lazy.nvim in different locations
if vim.loop.fs_stat(lazypath) then
  vim.opt.rtp:prepend(lazypath)
  lazy_available = pcall(require, "lazy")
else
  -- Try system-installed lazy.nvim (NixOS)
  lazy_available = pcall(require, "lazy")

  if not lazy_available then
    if is_nixos then
      vim.notify(
        "NixOS detected - Consider installing lazy.nvim through system config",
        vim.log.levels.WARN,
        { title = "Lazy.nvim" }
      )
      return -- Exit early on NixOS if lazy.nvim not available
    else
      vim.notify("Installing lazy.nvim...", vim.log.levels.INFO, { title = "Lazy.nvim" })
      vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
      })
      vim.opt.rtp:prepend(lazypath)
      lazy_available = pcall(require, "lazy")
    end
  end
end

-- Exit early if lazy.nvim is not available
if not lazy_available then
  vim.notify("Lazy.nvim not available - running without plugin manager", vim.log.levels.WARN)
  return
end

-- Setup lazy.nvim
require("lazy").setup({
  -- Import plugin specifications from plugins directory
  -- This will automatically load all files in lua/plugins/*.lua
  { import = "plugins" },
}, {
  -- Lazy.nvim configuration options
  defaults = {
    lazy = true, -- By default, load plugins lazily
    version = false, -- Don't use version by default, use latest
  },

  install = {
    -- Install missing plugins on startup
    missing = true,
    -- Colorscheme to use while installing plugins
    colorscheme = { "tokyonight", "habamax", "default" },
  },

  checker = {
    -- Automatically check for plugin updates
    enabled = not is_nixos, -- Disable checker on NixOS (managed by system)
    frequency = 86400, -- Check once a day (in seconds)
    notify = false, -- Don't notify about updates
  },

  change_detection = {
    -- Automatically check for config file changes
    enabled = true,
    notify = false, -- Don't notify about changes
  },

  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      -- Disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

  ui = {
    -- UI configuration for lazy.nvim window
    border = "rounded",
    size = {
      width = 0.8,
      height = 0.8,
    },
    icons = {
      cmd = " ",
      config = " ",
      event = " ",
      ft = " ",
      init = " ",
      keys = " ",
      plugin = " ",
      runtime = " ",
      source = " ",
      start = " ",
      task = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },

  debug = false,
})

-- Set up keymaps for lazy.nvim
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Open Lazy" })
vim.keymap.set("n", "<leader>Li", "<cmd>Lazy install<cr>", { desc = "Lazy: Install plugins" })
vim.keymap.set("n", "<leader>Lu", "<cmd>Lazy update<cr>", { desc = "Lazy: Update plugins" })
vim.keymap.set("n", "<leader>Ls", "<cmd>Lazy sync<cr>", { desc = "Lazy: Sync plugins" })
vim.keymap.set("n", "<leader>Lc", "<cmd>Lazy check<cr>", { desc = "Lazy: Check for updates" })
vim.keymap.set("n", "<leader>Ll", "<cmd>Lazy log<cr>", { desc = "Lazy: View log" })
vim.keymap.set("n", "<leader>Lp", "<cmd>Lazy profile<cr>", { desc = "Lazy: Profile startup" })
vim.keymap.set("n", "<leader>Lx", "<cmd>Lazy clean<cr>", { desc = "Lazy: Clean unused plugins" })
