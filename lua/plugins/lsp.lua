-- ~/.config/nvim/lua/plugins/lsp.lua
-- LSP, Mason, linters, formatters, and diagnostics configuration

return {
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
      
      -- TODO: Add LSP server configurations here
      -- Example: require("lspconfig").lua_ls.setup({})
    end,
  },
}
