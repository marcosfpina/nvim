-- ~/.config/nvim/lua/plugins/markdown.lua
-- Markdown support: in-buffer rendering via treesitter (no external deps)

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      completions = { lsp = { enabled = true } },
      heading = {
        sign = false,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        sign = false,
        width = "block",
        border = "thin",
      },
      bullet = {
        icons = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰱒 " },
      },
      pipe_table = {
        preset = "round",
      },
      -- Keep raw text visible on the cursor line for easy editing
      anti_conceal = { enabled = true },
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown render", ft = "markdown" },
      { "<leader>me", "<cmd>RenderMarkdown expand<cr>", desc = "Expand anti-conceal margin", ft = "markdown" },
      { "<leader>mc", "<cmd>RenderMarkdown contract<cr>", desc = "Contract anti-conceal margin", ft = "markdown" },
    },
  },
}
