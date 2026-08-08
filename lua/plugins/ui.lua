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
          colors.bg = "#101418"
          colors.bg_dark = "#0b0f13"
          colors.bg_float = "#151b21"
          colors.bg_highlight = "#1c242c"
          colors.bg_sidebar = "#0d1217"
          colors.terminal_black = "#6e7681"
          colors.fg = "#e6edf3"
          colors.fg_dark = "#9ba7b4"
          colors.fg_gutter = "#4b5563"
          colors.comment = "#7d8590"
          colors.dark3 = "#27313a"
          colors.dark5 = "#5b6672"
          colors.blue = "#7cc7ff"
          colors.cyan = "#76e3ea"
          colors.green = "#7ee787"
          colors.magenta = "#d2a8ff"
          colors.orange = "#ffb86b"
          colors.yellow = "#f2cc60"
          colors.red = "#ff7b72"
          colors.teal = "#4fd1a5"
          colors.git = {
            add = "#7ee787",
            change = "#7cc7ff",
            delete = "#ff7b72",
          }
          colors.hint = colors.teal
          colors.error = colors.red
          colors.warning = colors.orange
          colors.info = colors.blue
        end,
        on_highlights = function(highlights, colors)
          highlights.LineNr = { fg = colors.dark5 }
          highlights.CursorLineNr = { fg = colors.green, bold = true }
          highlights.CursorLine = { bg = colors.bg_highlight }
          highlights.Normal = { fg = colors.fg, bg = colors.bg }
          highlights.NormalFloat = { fg = colors.fg, bg = colors.bg_float }
          highlights.FloatBorder = { fg = colors.dark3, bg = colors.bg_float }
          highlights.BorderBG = { fg = colors.dark3, bg = colors.bg_float }
          highlights.WinSeparator = { fg = colors.dark3 }
          highlights.SignColumn = { bg = colors.bg }
          highlights.Pmenu = { fg = colors.fg, bg = colors.bg_float }
          highlights.PmenuSel = { fg = colors.fg, bg = colors.bg_highlight, bold = true }
          highlights.PmenuSbar = { bg = colors.dark3 }
          highlights.PmenuThumb = { bg = colors.dark5 }
          highlights.TelescopePromptPrefix = { fg = colors.green }
          highlights.TelescopeNormal = { fg = colors.fg, bg = colors.bg_float }
          highlights.TelescopeBorder = { fg = colors.dark3, bg = colors.bg_float }
          highlights.TelescopePromptNormal = { fg = colors.fg, bg = colors.bg_highlight }
          highlights.TelescopePromptBorder = { fg = colors.dark3, bg = colors.bg_highlight }
          highlights.TelescopePromptTitle = { fg = colors.bg_dark, bg = colors.green, bold = true }
          highlights.TelescopePreviewTitle = { fg = colors.bg_dark, bg = colors.blue, bold = true }
          highlights.TelescopeResultsTitle = { fg = colors.bg_dark, bg = colors.orange, bold = true }
          highlights.TelescopeSelection = { fg = colors.fg, bg = colors.bg_highlight, bold = true }
          highlights.TelescopeSelectionCaret = { fg = colors.green, bg = colors.bg_highlight, bold = true }
          highlights.TelescopeMatching = { fg = colors.cyan, bold = true }
          highlights.CmpItemAbbr = { fg = colors.fg }
          highlights.CmpItemAbbrMatch = { fg = colors.cyan, bold = true }
          highlights.CmpItemAbbrMatchFuzzy = { fg = colors.blue, bold = true }
          highlights.CmpItemMenu = { fg = colors.comment, italic = true }
          highlights.CmpItemKindVariable = { fg = colors.fg }
          highlights.CmpItemKindFunction = { fg = colors.blue }
          highlights.CmpItemKindMethod = { fg = colors.blue }
          highlights.CmpItemKindKeyword = { fg = colors.green }
          highlights.CmpItemKindClass = { fg = colors.cyan }
          highlights.CmpItemKindInterface = { fg = colors.cyan }
          highlights.CmpItemKindModule = { fg = colors.orange }
          highlights.CmpItemKindProperty = { fg = colors.red }
          highlights.CmpItemKindField = { fg = colors.red }
          highlights.CmpItemKindValue = { fg = colors.magenta }
          highlights.CmpItemKindConstant = { fg = colors.magenta }
          highlights.CmpItemKindSnippet = { fg = colors.orange }
          highlights.Visual = { bg = "#264f78" }
          highlights.VisualNOS = { bg = "#264f78" }
          highlights.LspReferenceText = { bg = colors.bg_highlight }
          highlights.LspReferenceRead = { bg = colors.bg_highlight }
          highlights.LspReferenceWrite = { bg = colors.bg_highlight, underline = true }
          highlights.Search = { fg = colors.bg_dark, bg = colors.yellow }
          highlights.IncSearch = { fg = colors.bg_dark, bg = colors.orange }
          highlights.String = { fg = colors.yellow }
          highlights.Character = { fg = colors.yellow }
          highlights.Number = { fg = colors.magenta }
          highlights.Boolean = { fg = colors.magenta, italic = true }
          highlights.Float = { fg = colors.magenta }
          highlights.Function = { fg = colors.blue, bold = true }
          highlights["@function"] = { fg = colors.blue, bold = true }
          highlights["@function.builtin"] = { fg = colors.cyan, bold = true, italic = true }
          highlights["@method"] = { fg = colors.blue }
          highlights["@constructor"] = { fg = colors.blue, bold = true }
          highlights.Keyword = { fg = colors.green, italic = true }
          highlights.Conditional = { fg = colors.green, italic = true }
          highlights.Repeat = { fg = colors.green, italic = true }
          highlights.Statement = { fg = colors.green }
          highlights.Operator = { fg = "#c9d1d9" }
          highlights["@keyword"] = { fg = colors.green, italic = true }
          highlights["@keyword.function"] = { fg = colors.green, italic = true }
          highlights["@keyword.return"] = { fg = colors.green, italic = true }
          highlights.Type = { fg = colors.cyan, bold = true }
          highlights["@type"] = { fg = colors.cyan, bold = true }
          highlights["@type.builtin"] = { fg = colors.cyan, italic = true }
          highlights["@property"] = { fg = colors.red }
          highlights["@field"] = { fg = colors.red }
          highlights["@variable"] = { fg = colors.fg }
          highlights["@variable.builtin"] = { fg = colors.red, italic = true }
          highlights["@constant"] = { fg = colors.magenta }
          highlights["@constant.builtin"] = { fg = colors.magenta, italic = true }
          highlights["@parameter"] = { fg = colors.fg_dark }
          highlights["@markup.heading"] = { fg = colors.blue, bold = true }
          highlights["@markup.strong"] = { fg = colors.fg, bold = true }
          highlights["@markup.italic"] = { fg = colors.fg_dark, italic = true }
          highlights["@markup.quote"] = { fg = colors.comment, italic = true }
          highlights["@markup.raw"] = { fg = colors.yellow }
          highlights["@markup.raw.block"] = { fg = colors.yellow, bg = colors.bg_highlight }
          highlights["@markup.link"] = { fg = colors.cyan, underline = true }
          highlights["@markup.list"] = { fg = colors.green }
          highlights["@punctuation.special.markdown"] = { fg = colors.green }
          highlights.Comment = { fg = colors.comment, italic = true }
          highlights.DiagnosticVirtualTextError = { bg = "NONE", fg = colors.error }
          highlights.DiagnosticVirtualTextWarn = { bg = "NONE", fg = colors.warning }
          highlights.DiagnosticVirtualTextInfo = { bg = "NONE", fg = colors.info }
          highlights.DiagnosticVirtualTextHint = { bg = "NONE", fg = colors.hint }
          highlights.DiagnosticUnderlineError = { undercurl = true, sp = colors.error }
          highlights.DiagnosticUnderlineWarn = { underline = false }
          highlights.DiagnosticUnderlineInfo = { underline = false }
          highlights.DiagnosticUnderlineHint = { underline = false }
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
          always_divide_middle = true,
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
            { "filename", path = 1, shorting_target = 40, symbols = { modified = " [+]", readonly = " [ro]", unnamed = "[No Name]" } },
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
            { "searchcount", maxcount = 999, timeout = 120 },
          },
          lualine_x = {
            {
              function()
                local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
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
        winbar = {
          lualine_c = {
            {
              function() return require("nvim-navic").get_location() end,
              cond = function()
                local ok, navic = pcall(require, "nvim-navic")
                return ok and navic.is_available()
              end,
            },
          },
        },
        inactive_winbar = {
          lualine_c = {},
        },
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
        show_buffer_close_icons = false,
        show_close_icon = false,
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
        enabled = false,
        show_start = false,
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
        "                           Void V I M ",
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
            -- {
            --   icon = " ",
            --   icon_hl = "Title",
            --   desc = "Projects",
            --   desc_hl = "String",
            --   key = "p",
            --   key_hl = "Number",
            --   action = "Telescope projects",
            -- },
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
      pcall(function()
        require("core.notify").install()
      end)

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
      close_fold_kinds_for_ft = {
        default = { "imports", "comment" },
      },
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
        return ft_providers[filetype] or { "indent" }
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
      local animate = require("mini.animate")
      return {
        resize = {
          enable = false, -- Disable for perf
        },
        scroll = {
          enable = false, -- Disable scroll animation (Major stutter cause)
        },
        cursor = {
          enable = false, -- Disable cursor animation (Major stutter cause)
        },
        open = {
          enable = false,
        },
        close = {
          enable = false,
        }
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
