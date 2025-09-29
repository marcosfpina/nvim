# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a comprehensive Neovim configuration designed for modern development with advanced features including AI integrations, cloud development, and MCP (Model Context Protocol) support. The configuration follows a highly modular architecture optimized for maintainability and extensibility.

## Directory Structure

```
nvim/
├── init.lua                      # Entry point with lazy.nvim bootstrap
├── lazy-lock.json                # Plugin lockfile (managed by lazy.nvim)
├── lua/
│   ├── core/                     # Core Neovim settings
│   ├── ui/                       # UI and visual elements
│   ├── plugins/                  # Plugin specifications and configs
│   ├── keymaps/                  # Modular keymap definitions
│   ├── functions/                # Utility functions for keymaps and plugins
│   ├── config/                   # Environment-specific configurations
│   ├── mcp/                      # MCP server protocols and agents
│   └── utils/                    # Shared utilities and helpers
├── snippets/                     # Custom snippets for LuaSnip
└── templates/                    # File templates for new projects
```

## Core Modules

### `/lua/core/`
- **`init.lua`**: Core module entry point and initialization
- **`options.lua`**: Global Vim options, UI settings, performance optimizations
- **`autocmds.lua`**: Automated commands for file handling, events
- **`debug.lua`**: Enhanced debugging with profiling capabilities
- **`keymaps.lua`**: Central keymap loader that orchestrates all keymap modules

### `/lua/ui/`
- **`theme.lua`**: Tokyo Night theme customization and color scheme management
- **`statusline.lua`**: Lualine configuration with LSP integration and git status
- **`dashboard.lua`**: Alpha-nvim dashboard with project shortcuts
- **`notify.lua`**: Enhanced notifications with history and styling
- **`misc.lua`**: Indent guides, dressing.nvim, and other UI enhancements

## Plugin Organization

### `/lua/plugins/`
- **`init.lua`**: Central plugin loader using lazy.nvim with performance optimization
- **`lsp.lua`**: LSP configurations, Mason server management, diagnostics
- **`mcp.lua`**: Model Context Protocol integrations and server configurations
- **`ai.lua`**: AI and LLM integrations (Copilot, ChatGPT, local models)
- **`completion.lua`**: nvim-cmp setup with multiple sources and snippets
- **`git.lua`**: Git tools (gitsigns, fugitive, diffview)
- **`debug.lua`**: DAP debugging tools and configurations
- **`navigation.lua`**: Telescope, project.nvim, file finding
- **`explorer.lua`**: File explorer configuration (neo-tree or nvim-tree)
- **`terminal.lua`**: Terminal integration with toggleterm
- **`treesitter.lua`**: Syntax highlighting and code manipulation
- **`tools.lua`**: Miscellaneous editing tools (surround, commentary)

## Keymap Architecture

### `/lua/keymaps/`
Modular keymap system with logical grouping:
- **`init.lua`**: Central keymap loader and coordination
- **`general.lua`**: Core editor keymaps (navigation, editing, windows)
- **`lsp.lua`**: LSP-specific bindings (go-to-definition, references, formatting)
- **`ai.lua`**: AI assistant keymaps (completion, chat, code generation)
- **`git.lua`**: Git workflow keymaps (staging, commits, diffs)
- **`debug.lua`**: Debugging keymaps (breakpoints, stepping, inspection)
- **`navigation.lua`**: Search and navigation keymaps (Telescope, file finding)
- **`whichkey.lua`**: Which-key UI configuration and grouped mappings

Key prefix organization:
- `<leader>a` - AI and assistant functions
- `<leader>b` - Buffer operations
- `<leader>c` - Code actions and LSP
- `<leader>d` - Debug operations
- `<leader>f` - Find and search
- `<leader>g` - Git operations
- `<leader>m` - MCP and model operations
- `<leader>p` - Project management
- `<leader>t` - Terminal and toggles
- `<leader>u` - UI and configuration
- `<leader>w` - Window operations

## Utility Functions

### `/lua/functions/`
- **`cmp.lua`**: Completion utilities and custom sources
- **`copilot.lua`**: AI assistant utilities and prompt management
- **`dap.lua`**: Debugging utilities and configuration helpers
- **`git.lua`**: Git operation utilities and workflow automation
- **`telescope.lua`**: Custom Telescope pickers and extensions

### `/lua/utils/`
- **`init.lua`**: Utility loader and common functions
- **`icons.lua`**: Comprehensive icon definitions for UI consistency

## Environment-Specific Configuration

### `/lua/config/`
- **`cloud.lua`**: Cloud platform integrations (Azure, AWS, GCP)
- **`docker.lua`**: Docker container development support
- **`kubernetes.lua`**: Kubernetes cluster management and deployment
- **`security.lua`**: Security settings, mTLS, SPIFFE integration

## MCP (Model Context Protocol) Integration

### `/lua/mcp/`
- **`init.lua`**: MCP module initialization and coordination
- **`agents.lua`**: Inline MCP agents for AI/LLM interactions
- **`servers.lua`**: MCP server configurations and protocol management

## Development Commands

### Configuration Management
```bash
# Reload configuration
:source ~/.config/nvim/init.lua

# Open config directory in Telescope
<leader>fc

# Edit specific configuration modules
<leader>fC
```

### Plugin Management
```bash
# Plugin manager operations
:Lazy                    # Open Lazy plugin manager
:Lazy update            # Update all plugins
:Lazy install           # Install new plugins
:Lazy profile           # Profile startup time
```

### LSP Operations
```bash
# LSP management
:Mason                  # Open Mason installer
:LspInfo               # Show LSP client information
:LspRestart            # Restart LSP servers

# Code actions
<leader>ca             # Code actions
<leader>cf             # Format document
<leader>cr             # Rename symbol
```

### AI and MCP Operations
```bash
# AI assistant functions
<leader>ac             # AI chat
<leader>ag             # AI code generation
<leader>ae             # AI explain code

# MCP operations
<leader>mc             # Connect to MCP server
<leader>ma             # MCP agent interaction
```

## File Templates and Snippets

### `/snippets/`
Custom LuaSnip snippets organized by filetype:
- Language-specific code templates
- Documentation templates
- Common patterns and boilerplate

### `/templates/`
Project templates for quick initialization:
- Language-specific project structures
- Configuration files
- CI/CD templates

## Performance Considerations

### Lazy Loading Strategy
- Plugins loaded based on events (BufReadPre, BufNewFile, VeryLazy)
- Conditional loading based on file types
- Optimized startup time with strategic plugin loading

### Memory Management
- Disabled unnecessary providers
- Optimized treesitter configurations
- Efficient LSP client management

## Development Guidelines

### Adding New Features
1. **Plugins**: Add to appropriate plugin file in `/lua/plugins/`
2. **Keymaps**: Create in corresponding keymap module in `/lua/keymaps/`
3. **Utilities**: Add helper functions to `/lua/functions/`
4. **Configuration**: Environment-specific settings in `/lua/config/`

### Code Organization
- Follow the modular structure strictly
- Use the established utility functions
- Maintain consistent icon usage from `utils/icons.lua`
- Keep environment-specific code in `/lua/config/`

### MCP Integration
- MCP servers should be configured in `/lua/mcp/servers.lua`
- AI agents and interactions in `/lua/mcp/agents.lua`
- Use established patterns for protocol communication

### Testing and Debugging
- Use the enhanced debug module for profiling
- Leverage the DAP configuration for debugging
- Monitor startup performance with `:Lazy profile`

This architecture provides a scalable, maintainable foundation for a comprehensive Neovim development environment with modern tooling, AI integration, and cloud development capabilities.