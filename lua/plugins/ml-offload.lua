-- ~/.config/nvim/lua/plugins/ml-offload.lua
-- ML Offload integration for intelligent model inference with llama.cpp backend

return {
  {
    "ml-offload.nvim",
    dir = vim.fn.stdpath("config") .. "/lua/ml-offload",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "MLChat", "MLEmbed", "MLStatus", "MLModels" },
    keys = {
      {
        "<leader>mc",
        ":<c-u>lua require('ml-offload').chat()<cr>",
        desc = "ML Offload: Chat",
        mode = { "n", "v" },
      },
      {
        "<leader>ms",
        ":<c-u>lua require('ml-offload').status()<cr>",
        desc = "ML Offload: Status",
        mode = "n",
      },
      {
        "<leader>me",
        ":<c-u>lua require('ml-offload').embed_selection()<cr>",
        desc = "ML Offload: Embed Selection",
        mode = "v",
      },
      {
        "<leader>mm",
        ":<c-u>lua require('ml-offload').list_models()<cr>",
        desc = "ML Offload: List Models",
        mode = "n",
      },
    },
    opts = {
      -- API Configuration
      api_url = "http://127.0.0.1:8080",
      timeout = 30000, -- 30 seconds
      
      -- Default model settings
      model = "default", -- Will use whatever is loaded in llama-server
      
      -- Chat completion defaults
      chat_defaults = {
        temperature = 0.7,
        max_tokens = 2000,
        stream = false,
      },
      
      -- UI Configuration
      ui = {
        border = "rounded",
        width = 0.8,
        height = 0.6,
      },
    },
    config = function(_, opts)
      require("ml-offload").setup(opts)
    end,
  },
}
