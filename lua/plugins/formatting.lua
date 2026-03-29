-- ~/.config/nvim/lua/plugins/formatting.lua
-- Code formatting and linting

return {
  -- Conform.nvim for formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        graphql = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        -- Adicione conforme instalar as ferramentas:
        -- python = { "isort", "black" },
        -- go = { "goimports" },
        -- rust = { "rustfmt" },  -- vem com Rust toolchain
        -- c = { "clang_format" },
        -- cpp = { "clang_format" },
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return {
          timeout_ms = 500,
          lsp_fallback = true,
          stop_after_first = true,
        }
      end,
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        prettier = {
          prepend_args = {
            "--tab-width",
            "2",
            "--single-quote",
            "false",
            "--trailing-comma",
            "es5",
          },
        },
        black = {
          prepend_args = { "--line-length", "100" },
        },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      -- Commands to toggle format on save
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting for all buffers
          vim.g.disable_autoformat = true
        else
          vim.b.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })
    end,
  },

  -- nvim-lint for linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        lua = { "luacheck" },
        markdown = { "markdownlint" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        -- Adicione conforme instalar as ferramentas:
        -- javascript = { "eslint_d" },
        -- javascriptreact = { "eslint_d" },
        -- typescript = { "eslint_d" },
        -- typescriptreact = { "eslint_d" },
        -- python = { "pylint" },
      }

      -- Create autocommand which carries out the actual linting
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = lint_augroup,
        callback = function()
          -- Safely attempt linting, catching errors for missing linters
          local ok, err = pcall(lint.try_lint)
          if not ok and err then
            -- Silently ignore linter not found errors (ENOENT means binary not found)
            local err_str = tostring(err)
            if not (string.match(err_str, "ENOENT") or string.match(err_str, "no such file")) then
              vim.notify("Linting error: " .. err_str, vim.log.levels.WARN)
            end
          end
        end,
      })

      -- Custom linter configurations
      lint.linters.luacheck.args = {
        "--globals",
        "vim",
        "--formatter",
        "plain",
        "--codes",
        "--ranges",
        "-",
      }

      vim.keymap.set("n", "<leader>cl", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },

  -- Mason tool installer
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
    opts = {
      ensure_installed = {
        -- Formatters (essenciais)
        "stylua",
        "prettier",
        "shfmt",

        -- Linters (essenciais)
        "shellcheck",
        "markdownlint",
        "luacheck",

        -- Language servers (essenciais - outros já estão em lsp.lua)
        "lua-language-server",
        "bash-language-server",
        "json-lsp",
        "yaml-language-server",

        -- Adicione conforme necessário:
        -- Python: "pyright", "black", "isort", "pylint"
        -- TypeScript/JS: "typescript-language-server", "prettierd", "eslint_d"
        -- Go: "gopls", "goimports"
        -- Rust: "rust-analyzer"
        -- C/C++: "clangd", "clang-format"
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 24,
    },
  },
}
