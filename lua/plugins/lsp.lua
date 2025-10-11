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
      -- Setup logger
      local logger
      local core_debug_ok, core_debug = pcall(require, "core.debug.logger")
      
      if core_debug_ok and core_debug and core_debug.get_logger then
        logger = core_debug.get_logger("plugins.lsp.config")
      else
        logger = {
          info = function(m) print("INFO [LSP_P_FB]: " .. m) end,
          error = function(m) print("ERROR [LSP_P_FB]: " .. m) end,
          warn = function(m) print("WARN [LSP_P_FB]: " .. m) end,
          debug = function(m) print("DEBUG [LSP_P_FB]: " .. m) end,
        }
        logger.error("core.debug.get_logger not found. Using fallback for nvim-lspconfig.")
      end
      
      logger.info("Configuring nvim-lspconfig and its ecosystem...")
      
      -- TODO: Add LSP server configurations here
      -- Example: require("lspconfig").lua_ls.setup({})
    end,
  },
}
