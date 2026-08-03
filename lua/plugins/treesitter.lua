-- ~/.config/nvim/lua/plugins/treesitter.lua
-- Treesitter configuration for advanced syntax highlighting and code understanding

local disabled_filetypes = {
  [""] = true,
  ["NvimTree"] = true,
  ["TelescopePrompt"] = true,
  ["alpha"] = true,
  ["dashboard"] = true,
  ["help"] = true,
  ["lazy"] = true,
  ["mason"] = true,
  ["neo-tree"] = true,
  ["noice"] = true,
  ["notify"] = true,
  ["qf"] = true,
  ["trouble"] = true,
}

local disabled_buftypes = {
  help = true,
  nofile = true,
  prompt = true,
  quickfix = true,
  terminal = true,
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "windwp/nvim-ts-autotag",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "HiPhish/rainbow-delimiters.nvim",
    },
    keys = {
      { "<leader>ts", "<cmd>TSPlaygroundToggle<CR>", desc = "Toggle Treesitter Playground" },
      { "<leader>th", "<cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Highlight under cursor" },
    },
    opts = {
      ensure_installed = {
        -- Core languages
        "lua",
        "vim",
        "vimdoc",
        "query",
        
        -- Web development
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "jsonc",
        
        -- Backend
        "python",
        "go",
        "rust",
        "c",
        "cpp",
        "java",
        
        -- Scripting
        "bash",
        "fish",
        -- Note: zsh parser removed - install manually if needed
        
        -- Config files
        "yaml",
        "toml",
        "ini",
        
        -- Markup
        "markdown",
        "markdown_inline",
        
        -- Git
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "gitattributes",
        
        -- Docker & DevOps
        "dockerfile",
        "terraform",
        "nix",
        
        -- SQL
        "sql",
        
        -- Other
        "regex",
        "comment",
      },
      
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      
      -- Keep parser management explicit to avoid parser install/warning spam.
      auto_install = false,
      
      -- Ignore these languages
      ignore_install = {},
      
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(lang, buf)
          if vim.api.nvim_buf_get_name(buf) == "" then
            return true
          end

          if disabled_filetypes[vim.bo[buf].filetype] or disabled_buftypes[vim.bo[buf].buftype] then
            return true
          end

          if lang == "zsh" then
            return true
          end

          local max_filesize = 256 * 1024 -- 256 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      
      indent = {
        enable = true,
        disable = { "python", "yaml" }, -- These languages have better indent plugins
      },
      
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      
      -- nvim-ts-autotag
      autotag = {
        enable = true,
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = true,
        filetypes = {
          "html",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "vue",
          "tsx",
          "jsx",
          "xml",
          "markdown",
        },
      },
      
      -- Text objects
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["a/"] = "@comment.outer",
            ["i/"] = "@comment.inner",
          },
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "<c-v>",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.inner",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.inner",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.inner",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- Fix nvim-treesitter master-branch predicates crashing on Nvim 0.12+
      -- (see lua/core/ts-query-compat.lua)
      require("core.ts-query-compat").setup()

      -- Context commentstring
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })
      
      -- Integrate with Comment.nvim
      local get_option = vim.filetype.get_option
      local ts_commentstring = require("ts_context_commentstring.internal")
      vim.filetype.get_option = function(filetype, option)
        if option ~= "commentstring" then
          return get_option(filetype, option)
        end

        local ok, commentstring = pcall(ts_commentstring.calculate_commentstring)
        if ok and commentstring then
          return commentstring
        end

        return get_option(filetype, option)
      end
    end,
  },
  
  -- Treesitter context - shows context at top of buffer
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      enable = true,
      max_lines = 3,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
      zindex = 20,
    },
    keys = {
      {
        "<leader>ut",
        function()
          local tsc = require("treesitter-context")
          tsc.toggle()
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  },
  
  -- Rainbow delimiters
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  -- MDX support: registers the mdx filetype on the markdown parser and adds
  -- injection queries for JSX/import/export inside .mdx files.
  {
    "davidmh/mdx.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufEnter *.mdx",
  },
}
