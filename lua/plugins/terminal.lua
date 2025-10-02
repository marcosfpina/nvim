-- ~/.config/nvim/lua/plugins/terminal.lua
-- Terminal integration

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal", mode = { "n", "t" } },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Vertical terminal" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      autochdir = false,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
      float_opts = {
        border = "curved",
        width = function()
          return math.floor(vim.o.columns * 0.9)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.9)
        end,
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
      winbar = {
        enabled = false,
        name_formatter = function(term)
          return term.name
        end,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- Custom terminal commands
      local Terminal = require("toggleterm.terminal").Terminal

      -- Lazygit
      local lazygit = Terminal:new({
        cmd = "lazygit",
        direction = "float",
        float_opts = {
          border = "double",
          width = function()
            return math.floor(vim.o.columns * 0.95)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.95)
          end,
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      -- Node REPL
      local node = Terminal:new({
        cmd = "node",
        direction = "float",
        close_on_exit = false,
      })

      function _NODE_TOGGLE()
        node:toggle()
      end

      -- Python REPL
      local python = Terminal:new({
        cmd = "python",
        direction = "float",
        close_on_exit = false,
      })

      function _PYTHON_TOGGLE()
        python:toggle()
      end

      -- Htop
      local htop = Terminal:new({
        cmd = "htop",
        direction = "float",
        close_on_exit = true,
      })

      function _HTOP_TOGGLE()
        htop:toggle()
      end

      -- Keymaps for custom terminals
      vim.keymap.set("n", "<leader>gg", _LAZYGIT_TOGGLE, { desc = "LazyGit" })
      vim.keymap.set("n", "<leader>tn", _NODE_TOGGLE, { desc = "Node REPL" })
      vim.keymap.set("n", "<leader>tp", _PYTHON_TOGGLE, { desc = "Python REPL" })
      vim.keymap.set("n", "<leader>tt", _HTOP_TOGGLE, { desc = "Htop" })

      -- Terminal mode mappings
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end

      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    end,
  },

  -- Enhanced git integration
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Commit" },
      { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Pull" },
      { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Push" },
    },
    opts = {
      kind = "tab",
      signs = {
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
      integrations = {
        telescope = true,
        diffview = true,
      },
      disable_commit_confirmation = false,
      disable_builtin_notifications = false,
      disable_insert_on_commit = false,
      filewatcher = {
        interval = 1000,
        enabled = true,
      },
      graph_style = "unicode",
      git_services = {
        ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
        ["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
      },
      telescope_sorter = function()
        return require("telescope").extensions.fzf.native_fzf_sorter()
      end,
    },
  },

  -- Diffview for git
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
    },
    opts = {
      diff_binaries = false,
      enhanced_diff_hl = false,
      git_cmd = { "git" },
      hg_cmd = { "hg" },
      use_icons = true,
      show_help_hints = true,
      watch_index = true,
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      view = {
        default = {
          layout = "diff2_horizontal",
          winbar_info = false,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          winbar_info = false,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
          win_opts = {},
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
          win_opts = {},
        },
      },
      commit_log_panel = {
        win_config = {
          win_opts = {},
        },
      },
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      hooks = {},
      keymaps = {
        disable_defaults = false,
        view = {
          { "n", "<tab>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
          { "n", "gf", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
          { "n", "<leader>e", "<cmd>DiffviewFocusFiles<cr>", { desc = "Focus file panel" } },
          { "n", "<leader>b", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
          { "n", "[x", "<cmd>lua require('diffview.actions').prev_conflict()<cr>", { desc = "Next conflict" } },
          { "n", "]x", "<cmd>lua require('diffview.actions').next_conflict()<cr>", { desc = "Previous conflict" } },
          { "n", "<leader>co", "<cmd>lua require('diffview.actions').conflict_choose('ours')<cr>", { desc = "Choose ours" } },
          { "n", "<leader>ct", "<cmd>lua require('diffview.actions').conflict_choose('theirs')<cr>", { desc = "Choose theirs" } },
          { "n", "<leader>cb", "<cmd>lua require('diffview.actions').conflict_choose('base')<cr>", { desc = "Choose base" } },
          { "n", "<leader>ca", "<cmd>lua require('diffview.actions').conflict_choose('all')<cr>", { desc = "Choose all" } },
          { "n", "dx", "<cmd>lua require('diffview.actions').conflict_choose('none')<cr>", { desc = "Delete conflict" } },
        },
        file_panel = {
          { "n", "j", "<cmd>lua require('diffview.actions').next_entry()<cr>", { desc = "Next entry" } },
          { "n", "<down>", "<cmd>lua require('diffview.actions').next_entry()<cr>", { desc = "Next entry" } },
          { "n", "k", "<cmd>lua require('diffview.actions').prev_entry()<cr>", { desc = "Previous entry" } },
          { "n", "<up>", "<cmd>lua require('diffview.actions').prev_entry()<cr>", { desc = "Previous entry" } },
          { "n", "<cr>", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Select entry" } },
          { "n", "o", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Select entry" } },
          { "n", "<2-LeftMouse>", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Select entry" } },
          { "n", "-", "<cmd>lua require('diffview.actions').toggle_stage_entry()<cr>", { desc = "Stage/unstage" } },
          { "n", "S", "<cmd>lua require('diffview.actions').stage_all()<cr>", { desc = "Stage all" } },
          { "n", "U", "<cmd>lua require('diffview.actions').unstage_all()<cr>", { desc = "Unstage all" } },
          { "n", "X", "<cmd>lua require('diffview.actions').restore_entry()<cr>", { desc = "Restore entry" } },
          { "n", "L", "<cmd>lua require('diffview.actions').open_commit_log()<cr>", { desc = "Commit log" } },
          { "n", "zo", "<cmd>lua require('diffview.actions').open_fold()<cr>", { desc = "Open fold" } },
          { "n", "h", "<cmd>lua require('diffview.actions').close_fold()<cr>", { desc = "Close fold" } },
          { "n", "zc", "<cmd>lua require('diffview.actions').close_fold()<cr>", { desc = "Close fold" } },
          { "n", "za", "<cmd>lua require('diffview.actions').toggle_fold()<cr>", { desc = "Toggle fold" } },
          { "n", "zR", "<cmd>lua require('diffview.actions').open_all_folds()<cr>", { desc = "Open all folds" } },
          { "n", "zM", "<cmd>lua require('diffview.actions').close_all_folds()<cr>", { desc = "Close all folds" } },
          { "n", "<c-b>", "<cmd>lua require('diffview.actions').scroll_view(-0.25)<cr>", { desc = "Scroll up" } },
          { "n", "<c-f>", "<cmd>lua require('diffview.actions').scroll_view(0.25)<cr>", { desc = "Scroll down" } },
          { "n", "<tab>", "<cmd>lua require('diffview.actions').select_next_entry()<cr>", { desc = "Next file" } },
          { "n", "<s-tab>", "<cmd>lua require('diffview.actions').select_prev_entry()<cr>", { desc = "Previous file" } },
          { "n", "gf", "<cmd>lua require('diffview.actions').goto_file()<cr>", { desc = "Goto file" } },
          { "n", "<C-w><C-f>", "<cmd>lua require('diffview.actions').goto_file_split()<cr>", { desc = "Goto file split" } },
          { "n", "<C-w>gf", "<cmd>lua require('diffview.actions').goto_file_tab()<cr>", { desc = "Goto file tab" } },
          { "n", "i", "<cmd>lua require('diffview.actions').listing_style()<cr>", { desc = "Toggle listing style" } },
          { "n", "f", "<cmd>lua require('diffview.actions').toggle_flatten_dirs()<cr>", { desc = "Toggle flatten" } },
          { "n", "R", "<cmd>lua require('diffview.actions').refresh_files()<cr>", { desc = "Refresh" } },
          { "n", "<leader>e", "<cmd>lua require('diffview.actions').focus_files()<cr>", { desc = "Focus files" } },
          { "n", "<leader>b", "<cmd>lua require('diffview.actions').toggle_files()<cr>", { desc = "Toggle files" } },
        },
        file_history_panel = {
          { "n", "g!", "<cmd>lua require('diffview.actions').options()<cr>", { desc = "Options" } },
          { "n", "<C-A-d>", "<cmd>lua require('diffview.actions').open_in_diffview()<cr>", { desc = "Open in diffview" } },
          { "n", "y", "<cmd>lua require('diffview.actions').copy_hash()<cr>", { desc = "Copy hash" } },
          { "n", "L", "<cmd>lua require('diffview.actions').open_commit_log()<cr>", { desc = "Commit log" } },
          { "n", "zR", "<cmd>lua require('diffview.actions').open_all_folds()<cr>", { desc = "Open all folds" } },
          { "n", "zM", "<cmd>lua require('diffview.actions').close_all_folds()<cr>", { desc = "Close all folds" } },
          { "n", "j", "<cmd>lua require('diffview.actions').next_entry()<cr>", { desc = "Next entry" } },
          { "n", "<down>", "<cmd>lua require('diffview.actions').next_entry()<cr>", { desc = "Next entry" } },
          { "n", "k", "<cmd>lua require('diffview.actions').prev_entry()<cr>", { desc = "Previous entry" } },
          { "n", "<up>", "<cmd>lua require('diffview.actions').prev_entry()<cr>", { desc = "Previous entry" } },
          { "n", "<cr>", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Select entry" } },
          { "n", "o", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Select entry" } },
          { "n", "<2-LeftMouse>", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Select entry" } },
          { "n", "<c-b>", "<cmd>lua require('diffview.actions').scroll_view(-0.25)<cr>", { desc = "Scroll up" } },
          { "n", "<c-f>", "<cmd>lua require('diffview.actions').scroll_view(0.25)<cr>", { desc = "Scroll down" } },
          { "n", "<tab>", "<cmd>lua require('diffview.actions').select_next_entry()<cr>", { desc = "Next file" } },
          { "n", "<s-tab>", "<cmd>lua require('diffview.actions').select_prev_entry()<cr>", { desc = "Previous file" } },
          { "n", "gf", "<cmd>lua require('diffview.actions').goto_file()<cr>", { desc = "Goto file" } },
          { "n", "<C-w><C-f>", "<cmd>lua require('diffview.actions').goto_file_split()<cr>", { desc = "Goto file split" } },
          { "n", "<C-w>gf", "<cmd>lua require('diffview.actions').goto_file_tab()<cr>", { desc = "Goto file tab" } },
          { "n", "<leader>e", "<cmd>lua require('diffview.actions').focus_files()<cr>", { desc = "Focus files" } },
          { "n", "<leader>b", "<cmd>lua require('diffview.actions').toggle_files()<cr>", { desc = "Toggle files" } },
        },
        option_panel = {
          { "n", "<tab>", "<cmd>lua require('diffview.actions').select_entry()<cr>", { desc = "Select entry" } },
          { "n", "q", "<cmd>lua require('diffview.actions').close()<cr>", { desc = "Close" } },
        },
      },
    },
  },
}
