-- ~/.config/nvim/lua/plugins/lsp.lua
-- LSP, Mason, linters, formatters, and diagnostics configuration

return {
  -- LSP progress spinner
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },

  -- Mason for managing LSP servers, formatters, linters
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      -- NixOS: mason binaries are dynamically linked and can't run here;
      -- keep them out of PATH so nix-provided servers are the only source
      PATH = "skip",
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │                   LSP Core Configuration                 │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
      "folke/neodev.nvim",
      {
        "ray-x/lsp_signature.nvim",
        opts = {
          bind = true,
          handler_opts = { border = "rounded" },
          hint_enable = false,
        },
        event = "LspAttach",
      },
      "SmiteshP/nvim-navic",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Use global logger if available
      local logger = _G.log or {
        info = function(m) vim.notify("[INFO] " .. m, vim.log.levels.INFO) end,
        error = function(m) vim.notify("[ERROR] " .. m, vim.log.levels.ERROR) end,
        warn = function(m) vim.notify("[WARN] " .. m, vim.log.levels.WARN) end,
        debug = function(m) vim.notify("[DEBUG] " .. m, vim.log.levels.DEBUG) end,
      }

      logger.info("Configuring nvim-lspconfig and its ecosystem...")

      -- Setup neodev for Lua/Neovim development
      require("neodev").setup({
        library = {
          enabled = true,
          runtime = true,
          types = true,
          plugins = true,
        },
      })

      -- LSP Keymaps (on attach)
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }

        -- Navigation
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

        -- Workspace
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))

        -- Code actions
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))

        -- Inlay hints (native, nvim >= 0.10)
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          vim.keymap.set("n", "<leader>uh", function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
          end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
        end

        -- Highlight other references of the symbol under the cursor
        if client.server_capabilities.documentHighlightProvider then
          local hl_group = vim.api.nvim_create_augroup("LspDocumentHighlight" .. bufnr, { clear = true })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = hl_group,
            buffer = bufnr,
            callback = function()
              -- CursorHold also fires in visual mode; highlighting there reads
              -- as ghost shadows over the selection
              if vim.api.nvim_get_mode().mode:match("^[ni]") then
                vim.lsp.buf.document_highlight()
              end
            end,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
            group = hl_group,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- Diagnostics
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))

        -- Navic support for winbar breadcrumbs
        if client.server_capabilities.documentSymbolProvider then
          local navic_ok, navic = pcall(require, "nvim-navic")
          if navic_ok then
            navic.attach(client, bufnr)
          end
        end

        logger.info("LSP attached: " .. client.name)
      end

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = {
          spacing = 2,
          prefix = "●",
          source = "if_many",
          severity = { min = vim.diagnostic.severity.WARN },
        },
        signs = true,
        underline = {
          severity = vim.diagnostic.severity.ERROR,
        },
        update_in_insert = false,
        severity_sort = true,
        severity = {
          min = vim.diagnostic.severity.HINT,
        },
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
          focusable = false,
          scope = "line",
        },
      })

      -- Diagnostic signs
      local signs = { Error = "●", Warn = "▲", Hint = "•", Info = "•" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- hover/signature_help borders are handled by noice.nvim (lsp.hover.enabled / lsp.signature.enabled)

      -- Get capabilities from nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- Setup mason-lspconfig (with error handling)
      local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
      if mason_lspconfig_ok then
        local setup_ok, _ = pcall(function()
          mason_lspconfig.setup({
            -- NixOS: never auto-enable mason-installed servers (their binaries
            -- don't run here); setup_server below gates on real PATH executables
            automatic_enable = false,
            ensure_installed = {
              "lua_ls",
              "bashls",
              "jsonls",
              "yamlls",
              -- Adicione conforme necessário:
              -- "pyright",      -- Python
              -- "ts_ls",        -- TypeScript/JavaScript
              -- "rust_analyzer",-- Rust
              -- "gopls",        -- Go
              -- "clangd",       -- C/C++
            },
            automatic_installation = true,
          })
        end)

        if not setup_ok then
          logger.warn("mason-lspconfig setup failed, falling back to manual setup")
        end
      else
        logger.warn("mason-lspconfig not available, using manual LSP setup")
      end

      -- Servers whose binary isn't on PATH: collected and logged once at the
      -- end (quietly) instead of one popup per server on every startup
      local skipped_servers = {}

      -- LSP Server setup function using new vim.lsp.config API
      local function setup_server(server_name, server_config)
        local default_config = {
          on_attach = on_attach,
          capabilities = capabilities,
        }

        local config = server_config and vim.tbl_deep_extend("force", default_config, server_config) or default_config

        -- NixOS: Mason binaries don't run here, so only enable servers whose
        -- executable actually resolves on PATH (nix-provided or system-wide)
        local exe = config.cmd and config.cmd[1]
        if exe and vim.fn.executable(exe) == 0 then
          table.insert(skipped_servers, server_name .. " (" .. exe .. ")")
          return
        end

        local setup_ok, _ = pcall(function()
          -- Define the LSP config using the new API
          vim.lsp.config(server_name, config)
          -- Enable the server
          vim.lsp.enable(server_name)
        end)

        if setup_ok then
          logger.info("LSP server configured: " .. server_name)
        else
          logger.warn("Failed to setup LSP server: " .. server_name)
        end
      end

      -- Setup LSP servers directly (more reliable than setup_handlers)

      -- Lua
      setup_server("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
            telemetry = { enable = false },
            hint = { enable = true },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      })

      -- Bash
      setup_server("bashls", {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash" },
      })

      -- JSON
      setup_server("jsonls", {
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- YAML
      setup_server("yamlls", {
        cmd = { "yaml-language-server", "--stdio" },
        filetypes = { "yaml", "yaml.docker-compose" },
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })

      -- Optional servers (uncomment if needed)

      -- Python
      -- setup_server("pyright", {
      --   settings = {
      --     python = {
      --       analysis = {
      --         autoSearchPaths = true,
      --         diagnosticMode = "workspace",
      --         useLibraryCodeForTypes = true,
      --         typeCheckingMode = "basic",
      --       },
      --     },
      --   },
      -- })

      -- TypeScript/JavaScript
      -- setup_server("ts_ls", {
      --   settings = {
      --     typescript = {
      --       inlayHints = {
      --         includeInlayParameterNameHints = "all",
      --         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      --         includeInlayFunctionParameterTypeHints = true,
      --         includeInlayVariableTypeHints = true,
      --         includeInlayPropertyDeclarationTypeHints = true,
      --         includeInlayFunctionLikeReturnTypeHints = true,
      --         includeInlayEnumMemberValueHints = true,
      --       },
      --     },
      --     javascript = {
      --       inlayHints = {
      --         includeInlayParameterNameHints = "all",
      --         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      --         includeInlayFunctionParameterTypeHints = true,
      --         includeInlayVariableTypeHints = true,
      --         includeInlayPropertyDeclarationTypeHints = true,
      --         includeInlayFunctionLikeReturnTypeHints = true,
      --         includeInlayEnumMemberValueHints = true,
      --       },
      --     },
      --   },
      -- })

      -- Rust
      -- setup_server("rust_analyzer", {
      --   settings = {
      --     ["rust-analyzer"] = {
      --       checkOnSave = {
      --         command = "clippy",
      --       },
      --       cargo = {
      --         allFeatures = true,
      --       },
      --     },
      --   },
      -- })

      -- Go
      setup_server("gopls", {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_markers = { "go.work", "go.mod", ".git" },
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      })

      -- Nix: prefer nixd, fall back to nil (both nix-provided; skipped if absent)
      if vim.fn.executable("nixd") == 1 then
        setup_server("nixd", {
          cmd = { "nixd" },
          filetypes = { "nix" },
          root_markers = { "flake.nix", ".git" },
          settings = {
            nixd = {
              formatting = { command = { "nixfmt" } },
            },
          },
        })
      else
        setup_server("nil_ls", {
          cmd = { "nil" },
          filetypes = { "nix" },
          root_markers = { "flake.nix", ".git" },
        })
      end

      if #skipped_servers > 0 then
        logger.debug("LSP servers skipped (not on PATH): " .. table.concat(skipped_servers, ", "))
      end

      logger.info("LSP configuration complete!")
    end,
  },
}
