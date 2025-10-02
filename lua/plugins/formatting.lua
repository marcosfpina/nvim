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
        python = { "isort", "black" },
        javascript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        vue = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        scss = { { "prettierd", "prettier" } },
        less = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        jsonc = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        ["markdown.mdx"] = { { "prettierd", "prettier" } },
        graphql = { { "prettierd", "prettier" } },
        handlebars = { { "prettierd", "prettier" } },
        go = { "goimports", "gofmt" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        fish = { "fish_indent" },
        toml = { "taplo" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        java = { "google-java-format" },
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return {
          timeout_ms = 500,
          lsp_fallback = true,
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
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        python = { "pylint" },
        go = { "golangcilint" },
        rust = { "cargo" },
        lua = { "luacheck" },
        dockerfile = { "hadolint" },
        yaml = { "yamllint" },
        json = { "jsonlint" },
        markdown = { "markdownlint" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      }

      -- Create autocommand which carries out the actual linting
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
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
        -- Formatters
        "stylua",
        "black",
        "isort",
        "prettier",
        "prettierd",
        "shfmt",
        "gofmt",
        "goimports",
        "rustfmt",
        "clang-format",
        "google-java-format",
        "terraform-fmt",
        "taplo",

        -- Linters
        "eslint_d",
        "pylint",
        "shellcheck",
        "markdownlint",
        "yamllint",
        "hadolint",
        "luacheck",

        -- Language servers (will configure in lsp.lua)
        "lua-language-server",
        "pyright",
        "typescript-language-server",
        "tailwindcss-language-server",
        "html-lsp",
        "css-lsp",
        "json-lsp",
        "yaml-language-server",
        "gopls",
        "rust-analyzer",
        "clangd",
        "bashls",
        "dockerls",
        "docker-compose-language-service",
        "terraform-ls",

        -- DAP
        "debugpy",
        "js-debug-adapter",
        "codelldb",
        "delve",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 24,
    },
  },
}
