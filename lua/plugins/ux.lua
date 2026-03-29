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
    enabled = false,
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
    enabled = false,
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = false,
          suggestions = 20,
        },
        presets = {
          operators = false,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      operators = { gc = "Comments" },
      key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
      },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
      },
      window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
      },
      ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
      show_help = true, -- show help message on the command line when the popup is visible
      triggers = "auto", -- automatically setup triggers
      -- triggers = {"<leader>"} -- or specify a list manually
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      
      -- Register group names
      wk.register({
        ["<leader>b"] = { name = "Buffers" },
        ["<leader>c"] = { name = "Code" },
        ["<leader>cc"] = { name = "Copilot Chat" },
        ["<leader>d"] = { name = "Debug" },
        ["<leader>f"] = { name = "Find/Files" },
        ["<leader>g"] = { name = "Git" },
        ["<leader>h"] = { name = "Harpoon/Help" },
        ["<leader>l"] = { name = "LSP" },
        ["<leader>n"] = { name = "Noice" },
        ["<leader>q"] = { name = "Quit/Session" },
        ["<leader>r"] = { name = "Refactor" },
        ["<leader>s"] = { name = "Search" },
        ["<leader>sn"] = { name = "Noice" },
        ["<leader>t"] = { name = "Terminal/Toggle" },
        ["<leader>u"] = { name = "UI/Utils" },
        ["<leader>w"] = { name = "Window" },
        ["<leader>x"] = { name = "Trouble/Diagnostics" },
      })
    end,
  },
}
