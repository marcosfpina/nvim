-- ~/.config/nvim/lua/plugins/ui-enhancements.lua
-- Additional UI enhancements for a cleaner look

return {
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                 Noice - Better UI                        │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          timeout = 1500, -- Fast timeout: 1.5 seconds
          max_width = 60,
          max_height = 10,
          render = "compact",
          stages = "fade",
          top_down = true,
        },
      },
    },
    init = function()
      -- Ensure lazyredraw is disabled for Noice compatibility
      vim.opt.lazyredraw = false
    end,
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          silent = false,
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
        },
      },
      popupmenu = {
        enabled = true,
        backend = "nui",
        kind_icons = {},
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
        {
          view = "notify",
          filter = { event = "msg_showmode" },
        },
        -- Suppress better-escape.nvim notifications
        {
          filter = {
            event = "notify",
            find = "better%-escape",
          },
          opts = { skip = true },
        },
        -- Suppress vim.validate deprecation warnings
        {
          filter = {
            event = "msg_show",
            kind = "wmsg",
            find = "vim%.validate is deprecated",
          },
          opts = { skip = true },
        },
        -- Suppress which-key warnings
        {
          filter = {
            event = "notify",
            find = "which%-key",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            find = "which%-key",
          },
          opts = { skip = true },
        },
      },
    },
    keys = {
      { "<leader>sn", "<cmd>Noice<cr>", desc = "Noice Messages" },
      { "<leader>snl", "<cmd>Noice last<cr>", desc = "Noice Last Message" },
      { "<leader>snh", "<cmd>Noice history<cr>", desc = "Noice History" },
      { "<leader>sna", "<cmd>Noice all<cr>", desc = "Noice All" },
      { "<leader>snd", "<cmd>Noice dismiss<cr>", desc = "Dismiss All" },
    },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │              Scrollbar with Diagnostics                  │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    dependencies = {
      "kevinhwang91/nvim-hlslens",
      "lewis6991/gitsigns.nvim",
    },
    config = function()
      local scrollbar = require("scrollbar")
      local colors = require("tokyonight.colors").setup()

      scrollbar.setup({
        handle = {
          color = colors.bg_highlight,
          blend = 0,
        },
        marks = {
          Cursor = {
            text = "•",
            priority = 0,
            gui = nil,
            color = colors.blue,
            cterm = nil,
            color_nr = nil,
            highlight = "Normal",
          },
          Search = {
            text = { "-", "=" },
            priority = 1,
            gui = nil,
            color = colors.orange,
            cterm = nil,
            color_nr = nil,
            highlight = "Search",
          },
          Error = {
            text = { "-", "=" },
            priority = 2,
            gui = nil,
            color = colors.error,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticVirtualTextError",
          },
          Warn = {
            text = { "-", "=" },
            priority = 3,
            gui = nil,
            color = colors.warning,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticVirtualTextWarn",
          },
          Info = {
            text = { "-", "=" },
            priority = 4,
            gui = nil,
            color = colors.info,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticVirtualTextInfo",
          },
          Hint = {
            text = { "-", "=" },
            priority = 5,
            gui = nil,
            color = colors.hint,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticVirtualTextHint",
          },
          Misc = {
            text = { "-", "=" },
            priority = 6,
            gui = nil,
            color = colors.purple,
            cterm = nil,
            color_nr = nil,
            highlight = "Normal",
          },
          GitAdd = {
            text = "┆",
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "GitSignsAdd",
          },
          GitChange = {
            text = "┆",
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "GitSignsChange",
          },
          GitDelete = {
            text = "▁",
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "GitSignsDelete",
          },
        },
        excluded_buftypes = {
          "terminal",
        },
        excluded_filetypes = {
          "cmp_docs",
          "cmp_menu",
          "noice",
          "prompt",
          "TelescopePrompt",
          "dashboard",
          "alpha",
          "lazy",
          "mason",
        },
        autocmd = {
          render = {
            "BufWinEnter",
            "TabEnter",
            "TermEnter",
            "WinEnter",
            "CmdwinLeave",
            "TextChanged",
            "VimResized",
            "WinScrolled",
          },
        },
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = true,
          handle = true,
          search = true,
        },
      })

      require("scrollbar.handlers.gitsigns").setup()
      require("scrollbar.handlers.search").setup({
        calm_down = true,
        nearest_only = true,
      })
    end,
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                Search Highlighting                       │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    config = function()
      require("hlslens").setup({
        calm_down = true,
        nearest_only = true,
        nearest_float_when = "always",
      })

      local kopts = { noremap = true, silent = true }

      vim.keymap.set("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

      vim.keymap.set("n", "<Leader>l", "<Cmd>noh<CR>", { noremap = true, silent = true, desc = "Clear search highlight" })
    end,
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │              Indent Scope Animation                      │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      symbol = "│",
      options = { try_as_border = true },
      draw = {
        delay = 50,
        animation = function()
          return 10
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Focus Mode (Zen)                       │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
    opts = {
      window = {
        backdrop = 0.95,
        width = 120,
        height = 1,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = true },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
        kitty = {
          enabled = false,
          font = "+4",
        },
      },
    },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                 Dim Inactive Code                        │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    opts = {
      dimming = {
        alpha = 0.25,
        color = { "Normal", "#ffffff" },
        term_bg = "#000000",
        inactive = false,
      },
      context = 15,
      treesitter = true,
      expand = {
        "function",
        "method",
        "table",
        "if_statement",
      },
      exclude = {},
    },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │              Highlight Colors in Code                    │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
        sass = { enable = true, parsers = { "css" } },
        virtualtext = "■",
        always_update = false,
      },
      buftypes = {},
    },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                 Winbar Breadcrumbs                       │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, buffer)
          end
        end,
      })
    end,
    opts = function()
      return {
        separator = " › ",
        highlight = true,
        depth_limit = 5,
        icons = require("core.icons").kinds,
        lazy_update_context = true,
      }
    end,
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │            Alternative Colorschemes                      │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        mini = true,
        telescope = true,
        mason = true,
        noice = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
      },
    },
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {
      variant = "moon",
      dark_variant = "moon",
      dim_inactive_windows = false,
      extend_background_behind_borders = true,
      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },
    },
  },
}
