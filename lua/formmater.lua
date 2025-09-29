-- Super clean, async por default
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    javascript = { "prettier" },
    rust = { "rustfmt" },
    go = { "gofmt", "goimports" },
    -- Add quantos quiser
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})
 
