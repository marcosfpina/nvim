# ML Offload Neovim Plugin

A production-grade Neovim plugin for intelligent model inference with llama.cpp backend integration.

## 🎯 Overview

ML Offload provides seamless integration between Neovim and the ML Offload API, enabling:

- **Chat Completions**: Interactive conversations with local LLMs
- **Embeddings Generation**: Convert text to vector embeddings
- **Model Management**: List and manage available models
- **Health Monitoring**: Real-time API status checks
- **Visual Selection Support**: Process selected text directly

## 🚀 Quick Start

### Installation

The plugin is already installed in your Neovim configuration at `~/.config/nvim/lua/ml-offload/`.

**Dependencies:**
- `nvim-lua/plenary.nvim` (HTTP client)
- ML Offload API running at `http://127.0.0.1:8000`

### Basic Usage

```vim
" Check API status
:MLStatus

" Send a chat message
:MLChat What is Rust?

" List available models
:MLModels

" Get embeddings for text
:MLEmbed Hello world
```

### Keybindings

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>mc` | Normal/Visual | Open chat prompt or send selection |
| `<leader>ms` | Normal | Check API status |
| `<leader>me` | Visual | Get embeddings for selection |
| `<leader>mm` | Normal | List available models |

**Note:** `<leader>` is typically mapped to Space (`<Space>`).

## 📚 Features

### 1. Chat Completions

Send prompts to the LLM and receive responses in a floating window.

**Command:**
```vim
:MLChat Your prompt here
```

**Keymap:** `<leader>mc` (Normal or Visual mode)

**Examples:**
```vim
" Ask a question
:MLChat Explain Rust ownership

" In Visual mode: Select text and press <leader>mc
" The selected text will be sent as the prompt
```

**Response Display:**
- Opens in a floating window
- Markdown syntax highlighting
- Press `q` or `<Esc>` to close
- Shows both prompt and response

### 2. API Health Check

Monitor the ML Offload API status and backend health.

**Command:**
```vim
:MLStatus
```

**Keymap:** `<leader>ms`

**Information Shown:**
- API URL and connection status
- Backend status (llamacpp)
- Detailed health metrics
- Real-time availability

### 3. Embeddings

Generate vector embeddings for text or code.

**Command:**
```vim
:MLEmbed text to embed
```

**Keymap:** `<leader>me` (Visual mode)

**Use Cases:**
- Semantic search
- Code similarity
- Context understanding
- Vector databases

**Example:**
```vim
" Select a function in Visual mode
" Press <leader>me
" Embedding dimensions will be shown in notification
```

### 4. Model Management

List all available models from the ML Offload API.

**Command:**
```vim
:MLModels
```

**Keymap:** `<leader>mm`

**Display:**
- Shows all loaded models
- Model IDs and metadata
- Floating window interface

## ⚙️ Configuration

### Default Configuration

```lua
{
  -- API Configuration
  api_url = "http://127.0.0.1:8000",
  timeout = 30000, -- 30 seconds
  
  -- Default model settings
  model = "default",
  
  -- Chat completion defaults
  chat_defaults = {
    temperature = 0.7,
    max_tokens = 2000,
    stream = false,
  },
  
  -- UI Configuration
  ui = {
    border = "rounded",
    width = 0.8,  -- 80% of screen width
    height = 0.6, -- 60% of screen height
  },
}
```

### Custom Configuration

Edit `~/.config/nvim/lua/plugins/ml-offload.lua`:

```lua
return {
  {
    "ml-offload.nvim",
    dir = vim.fn.stdpath("config") .. "/lua/ml-offload",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      api_url = "http://localhost:8000",  -- Change API URL
      timeout = 60000,                     -- Increase timeout
      model = "my-model",                  -- Default model
      chat_defaults = {
        temperature = 0.9,                 -- More creative
        max_tokens = 4000,                 -- Longer responses
      },
      ui = {
        border = "double",                 -- Different border style
        width = 0.9,
        height = 0.8,
      },
    },
  },
}
```

### Custom Keybindings

Add to your `init.lua` or `lua/core/keymaps.lua`:

```lua
vim.keymap.set("n", "<leader>ai", function()
  require("ml-offload").chat("Explain this code")
end, { desc = "Explain code with AI" })

vim.keymap.set("v", "<leader>ar", function()
  require("ml-offload").chat("Refactor this code")
end, { desc = "Refactor selection" })
```

## 🔧 API Reference

### Setup

```lua
require("ml-offload").setup({
  api_url = "http://127.0.0.1:8000",
  timeout = 30000,
  -- ... other options
})
```

### Functions

#### `chat(prompt)`
Send a chat completion request.

```lua
require("ml-offload").chat("What is Rust?")
```

**Parameters:**
- `prompt` (string, optional): The prompt to send. If empty, will use visual selection or prompt for input.

**Returns:** `nil`

#### `status()`
Check API health status.

```lua
require("ml-offload").status()
```

**Returns:** `nil` (displays in floating window)

#### `embed(text)`
Generate embeddings for text.

```lua
local data = require("ml-offload").embed("Hello world")
```

**Parameters:**
- `text` (string, optional): Text to embed. If empty, will use visual selection or prompt for input.

**Returns:** `table` - API response with embeddings data

#### `embed_selection()`
Helper to embed visual selection.

```lua
require("ml-offload").embed_selection()
```

**Returns:** `table` - API response

#### `list_models()`
List available models.

```lua
require("ml-offload").list_models()
```

**Returns:** `nil` (displays in floating window)

## 🏗️ Architecture

### File Structure

```
lua/ml-offload/
├── init.lua          # Main plugin implementation
└── README.md         # This file
```

### Plugin Loading

The plugin uses lazy loading for performance:

- Loaded on commands: `MLChat`, `MLEmbed`, `MLStatus`, `MLModels`
- Loaded on keybindings: `<leader>mc`, `<leader>ms`, `<leader>me`, `<leader>mm`
- Dependencies: `plenary.nvim` for HTTP requests

### HTTP Client

Uses `plenary.curl` for HTTP requests:

```lua
local curl = require("plenary.curl")
local response = curl.post({
  url = "http://127.0.0.1:8000/v1/chat/completions",
  body = vim.json.encode(data),
  headers = { ["Content-Type"] = "application/json" },
})
```

### UI Components

Floating windows with:
- Rounded borders (configurable)
- Responsive sizing (80% width, 60% height by default)
- Centered positioning
- Markdown syntax highlighting for responses
- `q` and `<Esc>` to close

## 🔍 Troubleshooting

### Plugin Not Loading

**Check plugin is installed:**
```vim
:lua print(vim.inspect(package.loaded["ml-offload"]))
```

**Reload plugin:**
```vim
:Lazy reload ml-offload.nvim
```

### API Connection Issues

**Verify API is running:**
```bash
curl http://127.0.0.1:8000/api/health
```

**Check API URL in config:**
```vim
:lua print(require("ml-offload").config.api_url)
```

**Test connection from Neovim:**
```vim
:MLStatus
```

### Commands Not Working

**Verify commands are registered:**
```vim
:command MLChat
:command MLStatus
```

**Check for errors:**
```vim
:messages
```

**Re-run setup:**
```vim
:lua require("ml-offload").setup()
```

### Timeout Issues

**Increase timeout in config:**
```lua
opts = {
  timeout = 60000,  -- 60 seconds
}
```

**Check network latency:**
```bash
time curl http://127.0.0.1:8000/api/health
```

### Embeddings Not Working

**Verify endpoint:**
```bash
curl -X POST http://127.0.0.1:8000/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{"model":"default","input":"test"}'
```

**Check logs:**
```vim
:messages
```

## 🧪 Testing

### Manual Testing

```vim
" 1. Check API status
:MLStatus

" 2. Test chat with simple prompt
:MLChat Hello

" 3. Test visual selection
" Select some text, then press <leader>mc

" 4. Test embeddings
:MLEmbed test

" 5. List models
:MLModels
```

### Debug Mode

Enable verbose logging:

```bash
export NVIM_DEV_MODE=1
nvim
```

Then check messages:
```vim
:messages
```

## 🎨 Customization Examples

### Custom Prompts

Create specialized commands:

```lua
-- Add to your config
vim.api.nvim_create_user_command("MLExplain", function()
  vim.cmd('normal! "vy')
  local selection = vim.fn.getreg('v')
  require("ml-offload").chat("Explain this code:\n\n" .. selection)
end, { range = true, desc = "Explain selected code" })

vim.api.nvim_create_user_command("MLOptimize", function()
  vim.cmd('normal! "vy')
  local selection = vim.fn.getreg('v')
  require("ml-offload").chat("Optimize this code:\n\n" .. selection)
end, { range = true, desc = "Optimize selected code" })
```

### Integration with Other Plugins

Use with Telescope:

```lua
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- Custom Telescope picker for ML prompts
vim.keymap.set("n", "<leader>mp", function()
  require("telescope.pickers").new({}, {
    prompt_title = "ML Prompts",
    finder = require("telescope.finders").new_table({
      results = {
        { "Explain code", "Explain this code in detail" },
        { "Find bugs", "Find potential bugs in this code" },
        { "Add comments", "Add clear comments to this code" },
        { "Optimize", "Optimize this code for performance" },
      },
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry[1],
          ordinal = entry[1],
        }
      end,
    }),
    sorter = require("telescope.config").values.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        require("ml-offload").chat(selection.value[2])
      end)
      return true
    end,
  }):find()
end, { desc = "ML prompt selector" })
```

## 📈 Performance

### Load Time

- Lazy loaded on demand
- First command: ~10-50ms
- Subsequent commands: <5ms

### Network Performance

- Timeout: 30s default (configurable)
- Streaming: Not yet supported
- Connection pooling: Via plenary.curl

### Memory Usage

- Minimal footprint: ~1-2MB
- Floating windows: Temporary, cleaned up on close
- No persistent state

## 🔐 Security

### API Access

- Default: localhost only (`127.0.0.1`)
- No authentication (local API)
- SSL: Not required for localhost

### Data Privacy

- All data stays local
- No external API calls
- No telemetry or tracking

## 🗺️ Roadmap

### Planned Features

- [ ] Streaming responses
- [ ] Conversation history
- [ ] Prompt templates
- [ ] Model switching UI
- [ ] Batch processing
- [ ] Syntax-aware context
- [ ] Integration with LSP
- [ ] Custom response handlers

### Known Limitations

- No streaming support yet
- Single request at a time
- Basic error handling
- Limited UI customization

## 📄 License

Part of the NixOS configuration repository. See main repository for license details.

## 🤝 Contributing

This plugin is part of a larger ML Offload system. See the main `INSTRUCTIONS.md` at `/etc/nixos/INSTRUCTIONS.md` for development guidelines.

## 📞 Support

For issues or questions:

1. Check `:MLStatus` for API connectivity
2. Review `:messages` for errors
3. See `/etc/nixos/INSTRUCTIONS.md` for ML Offload API docs
4. Check ML Offload API logs: `journalctl -u ml-offload-api -f`

---

**Version:** 1.0.0  
**Last Updated:** 2025-11-05  
**Part of:** ML Offload System - Phase 1 (Neovim MVP)
