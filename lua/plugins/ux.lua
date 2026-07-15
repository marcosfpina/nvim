-- ~/.config/nvim/lua/plugins/ux.lua
-- UX Improvements: Session, Smart Splits, Todo Comments, Renaming, Key Hints

return {
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Todo Comments                          │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "folke/todo-comments.nvim",
    enabled = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTelescope<cr>", desc = "Todo (Telescope)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search Todo" },
    },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Session Management                     │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
      options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
      pre_save = nil, -- a function to call before saving the session
    },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Incremental Rename                     │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
    keys = {
      {
        "<leader>rn",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Incremental Rename",
      },
    },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Smart Window Splits                    │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    opts = {
      ignored_events = {
        "BufEnter",
        "WinEnter",
      },
      resize_mode = {
        quit_key = "<ESC>",
        resize_keys = { "h", "j", "k", "l" },
        silent = true,
        hooks = {
          on_enter = nil,
          on_leave = nil,
        },
      },
      ignore_multiplexer = true, -- disable tmux integration for now to ensure pure nvim works
    },
    keys = {
      -- Resize
      { "<C-Left>", function() require("smart-splits").resize_left() end, desc = "Resize window left" },
      { "<C-Down>", function() require("smart-splits").resize_down() end, desc = "Resize window down" },
      { "<C-Up>", function() require("smart-splits").resize_up() end, desc = "Resize window up" },
      { "<C-Right>", function() require("smart-splits").resize_right() end, desc = "Resize window right" },
      -- Navigation
      { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left window" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to bottom window" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to top window" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right window" },
      -- Swapping
      { "<leader>wh", function() require("smart-splits").swap_buf_left() end, desc = "Swap buffer left" },
      { "<leader>wj", function() require("smart-splits").swap_buf_down() end, desc = "Swap buffer down" },
      { "<leader>wk", function() require("smart-splits").swap_buf_up() end, desc = "Swap buffer up" },
      { "<leader>wl", function() require("smart-splits").swap_buf_right() end, desc = "Swap buffer right" },
    },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Keybinding Hints                       │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      preset = "modern",
      win = { border = "rounded" },
      plugins = {
        marks = true,
        registers = true,
        spelling = { enabled = false },
      },
      spec = {
        { "<leader>b", group = "Buffers" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Debug" },
        { "<leader>f", group = "Find/Format" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Harpoon/Hunks" },
        { "<leader>l", group = "LSP" },
        { "<leader>m", group = "Markdown" },
        { "<leader>n", group = "Navigate/Noice" },
        { "<leader>o", group = "Options" },
        { "<leader>p", group = "Projects" },
        { "<leader>q", group = "Quit/Session" },
        { "<leader>r", group = "Refactor" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Terminal/Toggle" },
        { "<leader>u", group = "UI/Utils" },
        { "<leader>w", group = "Window" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>L", group = "Lazy" },
      },
    },
    keys = {
      {
        "<leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
