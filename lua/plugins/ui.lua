-- ~/.config/nvim/lua/plugins/ui.lua
-- UI enhancement plugins

return {
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Tokyo Night Theme                      │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = { bold = true },
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help", "terminal", "packer", "nvim-tree", "trouble", "telekasten", "spectre_panel" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = true,
        on_colors = function(colors)
          colors.hint = colors.orange
          colors.error = "#ff6666"
        end,
        on_highlights = function(highlights, colors)
          highlights.LineNr = { fg = colors.blue }
          highlights.TelescopePromptPrefix = { fg = colors.purple }
          highlights.DiagnosticVirtualTextError = { bg = colors.bg_dark, fg = colors.error }
          highlights.DiagnosticVirtualTextWarn = { bg = colors.bg_dark, fg = colors.warning }
          highlights.DiagnosticVirtualTextInfo = { bg = colors.bg_dark, fg = colors.info }
          highlights.DiagnosticVirtualTextHint = { bg = colors.bg_dark, fg = colors.hint }
        end,
      })
      
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Icons                                  │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      override = {
        zsh = {
          icon = "",
          color = "#428850",
          cterm_color = "65",
          name = "Zsh",
        },
      },
      color_icons = true,
      default = true,
      strict = true,
      override_by_filename = {
        [".gitignore"] = {
          icon = "",
          color = "#f1502f",
          name = "Gitignore",
        },
        ["docker-compose.yml"] = {
          icon = "󰡨",
          color = "#0db7ed",
          name = "DockerCompose",
        },
        ["Dockerfile"] = {
          icon = "󰡨",
          color = "#0db7ed",
          name = "Dockerfile",
        },
      },
      override_by_extension = {
        ["toml"] = {
          icon = "",
          color = "#6a8471",
          name = "Toml",
        },
        ["md"] = {
          icon = "",
          color = "#519aba",
          name = "Markdown",
        },
      },
    },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Status Line                            │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local icons = require("core.icons").diagnostics
      local theme = require("lualine.themes.tokyonight")
      
      return {
        options = {
          theme = theme,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
          disabled_filetypes = {
            statusline = { "dashboard", "alpha" },
            winbar = { "dashboard", "alpha", "neo-tree" },
          },
        },
        sections = {
          lualine_a = {
            { "mode", icon = "", separator = { left = "", right = "" }, right_padding = 2 },
          },
          lualine_b = {
            { "branch", icon = "" },
            {
              "diff",
              symbols = {
                added = " ",
                modified = " ",
                removed = " ",
              },
              colored = true,
            },
          },
          lualine_c = {
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = " ", readonly = " ", unnamed = " " } },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = {
                error = icons.Error .. " ",
                warn = icons.Warn .. " ",
                info = icons.Info .. " ",
                hint = icons.Hint .. " ",
              },
            },
            { "searchcount" },
          },
          lualine_x = {
            {
              function()
                local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
                if #buf_clients == 0 then
                  return "LSP Inactive"
                end
                
                local buf_client_names = {}
                for _, client in pairs(buf_clients) do
                  if client.name ~= "null-ls" and client.name ~= "copilot" then
                    table.insert(buf_client_names, client.name)
                  end
                end
                
                return "LSP: " .. table.concat(buf_client_names, ", ")
              end,
              icon = " ",
              color = { gui = "bold" },
            },
            { "encoding" },
            { "fileformat" },
            { "filetype", colored = true, icon_only = false },
          },
          lualine_y = {
            { "progress", separator = { left = "", right = "" }, left_padding = 2 },
          },
          lualine_z = {
            { "location", separator = { left = "", right = "" }, left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = { "filename" },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { "location" },
        },
        tabline = {},
        extensions = {
          "nvim-tree",
          "toggleterm",
          "quickfix",
          "symbols-outline",
          "trouble",
          "lazy",
          "mason",
          "nvim-dap-ui",
        },
      }
    end,
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Buffer Line                            │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Pick buffer" },
      { "<leader>bc", "<cmd>BufferLinePickClose<CR>", desc = "Pick buffer to close" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", desc = "Close buffers to the left" },
      { "<leader>br", "<cmd>BufferLineCloseRight<CR>", desc = "Close buffers to the right" },
      { "<leader>b1", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to buffer 1" },
      { "<leader>b2", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to buffer 2" },
      { "<leader>b3", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to buffer 3" },
      { "<leader>b4", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to buffer 4" },
      { "<leader>b5", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to buffer 5" },
    },
    opts = {
      options = {
        mode = "buffers",
        numbers = "none",
        close_command = function(bufnr)
          require("bufdelete").bufdelete(bufnr, false)
        end,
        right_mouse_command = function(bufnr)
          require("bufdelete").bufdelete(bufnr, false)
        end,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = {
            Error = " ",
            Warn = " ",
            Info = " ",
            Hint = " ",
          }
          local ret = {}
          for severity, icon in pairs(icons) do
            if diag[severity] then
              table.insert(ret, icon .. diag[severity])
            end
          end
          return table.concat(ret, " ")
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
          {
            filetype = "DiffviewFiles",
            text = "Diff View",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        separator_style = "thin",
        always_show_bufferline = false,
        sort_by = "id",
        indicator = {
          icon = "▎",
          style = "icon",
        },
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' },
        },
      },
      highlights = {
        buffer_selected = {
          bold = true,
          italic = false,
        },
      },
    },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Buffer Delete                          │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "famiu/bufdelete.nvim",
    event = "VeryLazy",
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Indent Guides                          │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
        injected_languages = true,
        highlight = { "Function", "Label" },
        priority = 500,
      },
      exclude = {
        filetypes = {
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
      },
    },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Dashboard                              │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local header = {
        " ",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣶⣦⣄⡀⠀⠀⠀⢀⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣦⣴⣿⣿⣿⣿⣿⣿⣶⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡄⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣿⣿⣿⣷⣦⣀⠀⠀⠀⠀",
        "⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀",
        "⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄",
        "⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⢿⣿⣿⣿⣿⣿⣿⣿⡿⢿⣿⣿⣿⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⠘⣿⣿⣿⣿⣿⣿⣿⠃⠄⢿⣿⣿⡇⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿",
        "⠀⠈⠻⣿⣿⣿⣿⣿⣷⣤⣈⣉⣉⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀",
        "⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⢀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀",
        "⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠛⠿⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⠿⠛⠛⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        " ",
        " N E O V I M - E N H A N C E D F O R 2 0 2 5 ",
        " ",
      }

      local opts = {
        theme = "doom",
        hide = {
          statusline = false,
          tabline = false,
          winbar = false,
        },
        config = {
          header = header,
          center = {
            {
              icon = " ",
              icon_hl = "Title",
              desc = "Find File",
              desc_hl = "String",
              key = "f",
              key_hl = "Number",
              action = "Telescope find_files",
            },
            {
              icon = " ",
              icon_hl = "Title",
              desc = "Recent Files",
              desc_hl = "String",
              key = "r",
              key_hl = "Number",
              action = "Telescope oldfiles",
            },
            {
              icon = " ",
              icon_hl = "Title",
              desc = "Find Word",
              desc_hl = "String",
              key = "g",
              key_hl = "Number",
              action = "Telescope live_grep",
            },
            {
              icon = " ",
              icon_hl = "Title",
              desc = "New File",
              desc_hl = "String",
              key = "n",
              key_hl = "Number",
              action = "enew",
            },
            {
              icon = " ",
              icon_hl = "Title",
              desc = "Projects",
              desc_hl = "String",
              key = "p",
              key_hl = "Number",
              action = "Telescope projects",
            },
            {
              icon = " ",
              icon_hl = "Title",
              desc = "Config",
              desc_hl = "String",
              key = "c",
              key_hl = "Number",
              action = "lua require('telescope.builtin').find_files({cwd = '~/.config/nvim/'})",
            },
            {
              icon = "󰒲 ",
              icon_hl = "Title",
              desc = "Lazy",
              desc_hl = "String",
              key = "l",
              key_hl = "Number",
              action = "Lazy",
            },
            {
              icon = " ",
              icon_hl = "Title",
              desc = "Quit",
              desc_hl = "String",
              key = "q",
              key_hl = "Number",
              action = "qa",
            },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return {
              "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
              "🧠 " .. vim.fn.system("date"):gsub("\n", ""),
            }
          end,
        },
      }

      require("dashboard").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dashboard",
        callback = function()
          vim.opt_local.showtabline = 0
        end,
      })
    end,
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Smooth Scrolling                       │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = true,
      cursor_scrolls_alone = true,
      easing_function = "quadratic",
      pre_hook = nil,
      post_hook = nil,
      performance_mode = false,
    },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Enhanced Notifications                 │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      stages = "fade",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      render = "wrapped-compact",
      background_colour = "#000000",
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify

      vim.keymap.set("n", "<leader>un", function()
        require("notify").dismiss({ silent = true, pending = true })
      end, { desc = "Dismiss all notifications" })

      vim.keymap.set("n", "<leader>unh", function()
        require("telescope").extensions.notify.notify()
      end, { desc = "View notification history" })
    end,
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Improved UI Components                 │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled = true,
        default_prompt = "Input:",
        prompt_align = "left",
        insert_only = true,
        anchor = "SW",
        border = "rounded",
        relative = "cursor",
        prefer_width = 40,
        width = nil,
        max_width = { 140, 0.9 },
        min_width = { 20, 0.2 },
        buf_options = {},
        win_options = {
          winblend = 10,
          wrap = false,
          list = true,
          listchars = "precedes:…,extends:…",
          sidescrolloff = 0,
        },
        mappings = {
          n = {
            ["<Esc>"] = "Close",
            ["<CR>"] = "Confirm",
          },
          i = {
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
            ["<Up>"] = "HistoryPrev",
            ["<Down>"] = "HistoryNext",
          },
        },
        override = function(conf)
          return conf
        end,
        get_config = nil,
      },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" },
        trim_prompt = true,
        telescope = {
          layout_strategy = "center",
          layout_config = {
            width = 0.8,
            height = 0.6,
          },
        },
        builtin = {
          anchor = "NW",
          border = "rounded",
          relative = "editor",
          buf_options = {},
          win_options = {
            winblend = 10,
          },
          width = nil,
          max_width = 0.8,
          min_width = 40,
          height = nil,
          max_height = 0.9,
          min_height = 10,
          mappings = {
            ["<Esc>"] = "Close",
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
          },
          override = function(conf)
            return conf
          end,
        },
        format_item_override = {},
        get_config = nil,
      },
    },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Folding with Preview                   │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup({
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          })
        end,
      },
    },
    event = "BufReadPost",
    keys = {
      {
        "zR",
        function() require("ufo").openAllFolds() end,
        desc = "Open all folds",
      },
      {
        "zM",
        function() require("ufo").closeAllFolds() end,
        desc = "Close all folds",
      },
      {
        "zr",
        function() require("ufo").openFoldsExceptKinds() end,
        desc = "Open folds except kinds",
      },
      {
        "zm",
        function() require("ufo").closeFoldsWith() end,
        desc = "Close folds with",
      },
      {
        "zp",
        function() require("ufo").peekFoldedLinesUnderCursor() end,
        desc = "Peek folded lines under cursor",
      },
    },
    opts = {
      open_fold_hl_timeout = 400,
      close_fold_kinds = { "imports", "comment" },
      preview = {
        win_config = {
          border = "rounded",
          winhighlight = "Normal:Folded",
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "[",
          jumpBot = "]",
        },
      },
      provider_selector = function(_, filetype, _)
        local ft_providers = {
          python = { "treesitter", "indent" },
          javascript = { "treesitter", "indent" },
          typescript = { "treesitter", "indent" },
          typescriptreact = { "treesitter", "indent" },
          javascriptreact = { "treesitter", "indent" },
          lua = { "treesitter", "indent" },
          markdown = { "treesitter", "indent" },
          vim = { "treesitter", "indent" },
          yaml = { "treesitter", "indent" },
          json = { "treesitter", "indent" },
          jsonc = { "treesitter", "indent" },
          rust = { "treesitter", "indent" },
          go = { "treesitter", "indent" },
          c = { "treesitter", "indent" },
          cpp = { "treesitter", "indent" },
        }
        return ft_providers[filetype] or { "treesitter", "indent" }
      end,
      enable_get_fold_virt_text = true,
      fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
        local result = {}
        local cur_width = 0
        local suffix = (" 󰁂 %d lines"):format(end_lnum - lnum)
        local suffix_width = vim.fn.strdisplaywidth(suffix)
        local target_width = width - suffix_width - 2
        
        for _, chunk in ipairs(virt_text) do
          local chunk_text = chunk[1]
          local chunk_width = vim.fn.strdisplaywidth(chunk_text)
          
          if cur_width + chunk_width > target_width then
            chunk_text = truncate(chunk_text, target_width - cur_width)
            chunk_width = vim.fn.strdisplaywidth(chunk_text)
            if chunk_width == 0 then
              break
            end
          end
          
          cur_width = cur_width + chunk_width
          table.insert(result, { chunk_text, chunk[2] })
          
          if cur_width >= target_width then
            break
          end
        end
        
        table.insert(result, { suffix, "UfoFoldedEllipsis" })
        return result
      end,
    },
    config = function(_, opts)
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" %d lines"):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          
          curWidth = curWidth + chunkWidth
        end
        
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end
      
      opts.fold_virt_text_handler = handler
      require("ufo").setup(opts)
      
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "Folded", { fg = "#7aa2f7", bg = "NONE" })
          vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", { fg = "#bb9af7" })
        end,
      })
    end,
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   UI Animations                          │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function()
      local mouse_scrolled = false
      
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end
      
      local animate = require("mini.animate")
      
      return {
        resize = {
          timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
          subroutines = {
            resize_window = animate.gen_subresize.window({ force_final = true }),
          },
        },
        scroll = {
          timing = animate.gen_timing.linear({ duration = 120, unit = "total" }),
          subscroll = animate.gen_subscroll.window({
            predicate = function()
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return true
            end,
          }),
        },
        cursor = {
          timing = animate.gen_timing.exponential({ ease = "in-out", duration = 120, unit = "total" }),
          path = animate.gen_path.angle(),
        },
        open = {
          timing = animate.gen_timing.exponential({ ease = "in-out", duration = 120, unit = "total" }),
        },
        close = {
          timing = animate.gen_timing.exponential({ ease = "in-out", duration = 80, unit = "total" }),
        },
      }
    end,
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   Window Maximizer                       │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "szw/vim-maximizer",
    keys = {
      { "<leader>wm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/restore window" },
    },
  },
}
