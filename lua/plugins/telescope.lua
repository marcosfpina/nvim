-- ~/.config/nvim/lua/plugins/telescope.lua
-- Telescope fuzzy finder and related plugins

return {
  -- Telescope core
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- Use latest commit
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      -- FZF native for better performance
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      -- File browser extension
      "nvim-telescope/telescope-file-browser.nvim",
      -- UI select extension (better vim.ui.select)
      "nvim-telescope/telescope-ui-select.nvim",
      -- Live grep args for advanced searching
      "nvim-telescope/telescope-live-grep-args.nvim",
      -- Project management - DISABLED
      -- "nvim-telescope/telescope-project.nvim",
      -- Frecency for smart file sorting
      {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = { "kkharji/sqlite.lua" },
      },
      -- Undo tree viewer
      "debugloop/telescope-undo.nvim",
      -- Better symbols search
      "nvim-telescope/telescope-symbols.nvim",
    },
    keys = {
      -- File pickers
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fc", "<cmd>Telescope find_files cwd=~/.config/nvim<cr>", desc = "Find Config Files" },
      { "<leader>fn", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
      { "<leader>fN", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "File Browser (cwd)" },
      
      -- Search pickers
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Grep Word Under Cursor" },
      { "<leader>fG", "<cmd>Telescope live_grep_args<cr>", desc = "Live Grep (Args)" },
      { "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in Buffer" },
      
      -- LSP pickers
      { "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
      { "<leader>fD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>fl", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>fL", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "gr", "<cmd>Telescope lsp_references<cr>", desc = "LSP References" },
      { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "LSP Implementations" },
      { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "LSP Type Definitions" },
      
      -- Git pickers
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
      { "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "Git Buffer Commits" },
      { "<leader>gB", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
      { "<leader>gS", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
      { "<leader>gt", "<cmd>Telescope git_stash<cr>", desc = "Git Stash" },
      
      -- Vim pickers
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
      { "<leader>fR", "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>fo", "<cmd>Telescope vim_options<cr>", desc = "Vim Options" },
      { "<leader>fa", "<cmd>Telescope autocommands<cr>", desc = "Autocommands" },
      { "<leader>fH", "<cmd>Telescope highlights<cr>", desc = "Highlights" },
      { "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>f:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>f/", "<cmd>Telescope search_history<cr>", desc = "Search History" },

      -- Extensions
      -- { "<leader>fp", "<cmd>Telescope project<cr>", desc = "Projects" }, -- Disabled
      { "<leader>fF", "<cmd>Telescope frecency<cr>", desc = "Frecency Files" },
      { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Undo Tree" },
      { "<leader>fe", "<cmd>Telescope symbols<cr>", desc = "Emoji & Symbols" },
      
      -- Resume & misc
      { "<leader>f.", "<cmd>Telescope resume<cr>", desc = "Resume Last Picker" },
      { "<leader><leader>", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
      { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
    },
    opts = function()
      local actions = require("telescope.actions")
      local actions_layout = require("telescope.actions.layout")

      -- trouble.nvim is loaded lazily (cmd/keys), so its module may not be on
      -- the runtimepath yet when telescope's opts are built. Force it to load
      -- on demand instead of requiring it eagerly here.
      local function trouble_open(...)
        pcall(function() require("lazy").load({ plugins = { "trouble.nvim" } }) end)
        local ok, trouble = pcall(require, "trouble.sources.telescope")
        if ok then
          trouble.open(...)
        end
      end

      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          entry_prefix = "  ",
          multi_icon = " ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_ignore_patterns = {
            "node_modules",
            "%.git/",
            "%.cache",
            "%.o",
            "%.a",
            "%.out",
            "%.class",
            "%.pdf",
            "%.mkv",
            "%.mp4",
            "%.zip",
            "%.tar.gz",
            "%.7z",
            "%.rar",
          },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-_>"] = actions.which_key, -- <C-/>
              ["<C-w>"] = { "<c-s-w>", type = "command" },
              ["<C-r>"] = actions.to_fuzzy_refine,
              ["<C-h>"] = actions_layout.toggle_preview,
              ["<C-s>"] = trouble_open,
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["?"] = actions.which_key,
              ["<C-h>"] = actions_layout.toggle_preview,
              ["<C-s>"] = trouble_open,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
            follow = true,
            hidden = true,
          },
          oldfiles = {
            cwd_only = false,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
          buffers = {
            ignore_current_buffer = true,
            sort_mru = true,
            sort_lastused = true,
            mappings = {
              i = {
                ["<c-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
          lsp_references = {
            show_line = false,
            trim_text = true,
          },
          lsp_definitions = {
            show_line = false,
            trim_text = true,
          },
          lsp_document_symbols = {
            symbol_width = 50,
          },
          lsp_workspace_symbols = {
            symbol_width = 50,
          },
          diagnostics = {
            theme = "ivy",
            initial_mode = "normal",
            layout_config = {
              preview_cutoff = 9999,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          file_browser = {
            theme = "dropdown",
            hijack_netrw = true,
            mappings = {
              ["i"] = {
                ["<C-w>"] = function() end, -- disable window close
              },
              ["n"] = {
                ["N"] = require("telescope").extensions.file_browser.actions.create,
                ["h"] = require("telescope").extensions.file_browser.actions.goto_parent_dir,
                ["/"] = function() end, -- disable search
              },
            },
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              winblend = 10,
              previewer = false,
              layout_config = {
                width = 0.5,
                height = 0.4,
              },
            }),
          },
          -- project = {
          --   base_dirs = {
          --     "~/projects",
          --     "~/.config",
          --   },
          --   hidden_files = true,
          --   theme = "dropdown",
          --   order_by = "asc",
          --   search_by = "title",
          --   sync_with_nvim_tree = true,
          -- },
          frecency = {
            show_scores = false,
            show_unindexed = true,
            ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*" },
            disable_devicons = false,
            workspaces = {
              ["conf"] = vim.fn.expand("~/.config"),
              ["nvim"] = vim.fn.expand("~/.config/nvim"),
              ["projects"] = vim.fn.expand("~/projects"),
            },
          },
          undo = {
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.8,
            },
            mappings = {
              i = {
                ["<cr>"] = require("telescope-undo.actions").yank_additions,
                ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
                ["<C-cr>"] = require("telescope-undo.actions").restore,
              },
            },
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }),
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      -- Load extensions
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "file_browser")
      pcall(telescope.load_extension, "ui-select")
      -- pcall(telescope.load_extension, "project") -- Disabled
      pcall(telescope.load_extension, "frecency")
      pcall(telescope.load_extension, "undo")
      pcall(telescope.load_extension, "live_grep_args")
      pcall(telescope.load_extension, "notify")
    end,
  },

  -- Trouble integration for better diagnostics
  {
    "folke/trouble.nvim",
    enabled = false,
    cmd = { "Trouble" },
    opts = {
      use_diagnostic_signs = true,
      action_keys = {
        close = "q",
        cancel = "<esc>",
        refresh = "r",
        jump = { "<cr>", "<tab>" },
        open_split = { "<c-x>" },
        open_vsplit = { "<c-v>" },
        open_tab = { "<c-t>" },
        jump_close = { "o" },
        toggle_mode = "m",
        toggle_preview = "P",
        hover = "K",
        preview = "p",
        close_folds = { "zM", "zm" },
        open_folds = { "zR", "zr" },
        toggle_fold = { "zA", "za" },
        previous = "k",
        next = "j",
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },
}
