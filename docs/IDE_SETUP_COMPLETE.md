# 🚀 Neovim IDE Complete Setup

## Overview

Your Neovim configuration has been transformed into a comprehensive, modern IDE optimized for development in 2025. Below is a complete summary of all features and capabilities.

## 📦 Plugin Categories

### 1. **Core UI & Experience**
- **TokyoNight Theme** - Modern colorscheme with customization
- **Lualine** - Feature-rich statusline with LSP info
- **Bufferline** - Enhanced buffer/tab management
- **Dashboard** - Beautiful startup screen
- **Indent Blankline** - Visual indent guides
- **nvim-notify** - Enhanced notifications
- **nvim-ufo** - Advanced code folding with preview
- **Neoscroll** - Smooth scrolling
- **Mini.animate** - UI animations
- **Dressing** - Better UI components

### 2. **File Management**
- **Neo-tree** - Modern file explorer (toggle with `<leader>e`)
- **Oil.nvim** - Buffer-like file operations (open with `-`)
- **Telescope** - Fuzzy finder for files, grep, and more
- **Telescope File Browser** - Advanced file browsing
- **Project.nvim** - Project management

### 3. **Code Intelligence (LSP)**
- **nvim-lspconfig** - LSP configurations
- **Mason** - Package manager for LSP servers
- **Mason-lspconfig** - Bridge between Mason and LSP
- **Mason-tool-installer** - Auto-install tools
- **lsp_signature** - Function signature hints
- **neodev.nvim** - Lua development for Neovim
- **Schemastore** - JSON schemas

**Supported Language Servers:**
- Lua (lua-language-server)
- Python (pyright)
- TypeScript/JavaScript (tsserver)
- Tailwind CSS
- HTML, CSS, JSON
- YAML
- Go (gopls)
- Rust (rust-analyzer)
- C/C++ (clangd)
- Bash
- Docker
- Terraform
- And more...

### 4. **Autocompletion**
- **nvim-cmp** - Completion engine
- **LuaSnip** - Snippet engine
- **friendly-snippets** - Snippet collection
- **lspkind** - VS Code-like icons
- **cmp sources**: LSP, buffer, path, cmdline, snippets

### 5. **Syntax & Treesitter**
- **nvim-treesitter** - Advanced syntax highlighting
- **Treesitter textobjects** - Smart text objects
- **nvim-ts-autotag** - Auto-close HTML tags
- **Rainbow delimiters** - Colorful bracket pairs
- **Treesitter context** - Sticky scroll context

**Supported Languages:**
40+ parsers including Lua, Python, JavaScript, TypeScript, Go, Rust, C/C++, HTML, CSS, JSON, YAML, Markdown, Bash, Docker, Terraform, and more

### 6. **Formatting & Linting**
- **conform.nvim** - Async formatting
- **nvim-lint** - Linting engine

**Formatters:**
- stylua, black, isort, prettier, prettierd, shfmt
- gofmt, goimports, rustfmt, clang-format
- terraform-fmt, taplo, and more

**Linters:**
- eslint_d, pylint, shellcheck, markdownlint
- yamllint, hadolint, luacheck, and more

### 7. **Git Integration**
- **Gitsigns** - Git signs in gutter with hunks
- **Neogit** - Magit-like git interface
- **Diffview** - Git diff viewer
- **LazyGit integration** via ToggleTerm

### 8. **Terminal**
- **ToggleTerm** - Integrated terminal
- Built-in terminals: LazyGit, Node REPL, Python REPL, Htop

### 9. **Diagnostics & Code Quality**
- **Trouble.nvim** - Beautiful diagnostics list
- **Todo-comments** - Highlight and search TODOs
- **nvim-bqf** - Better quickfix
- **Symbols-outline** - Symbol browser
- **Aerial** - Code outline

### 10. **Navigation**
- **Flash.nvim** - Lightning-fast navigation
- **nvim-spectre** - Project-wide search & replace
- **Marks.nvim** - Enhanced marks
- **Harpoon** - Quick file navigation

### 11. **AI Assistance**
- **Copilot.lua** - GitHub Copilot integration
- **CopilotChat** - Chat with Copilot in Neovim

### 12. **Editing Enhancements**
- **nvim-surround** - Surround text objects
- **Comment.nvim** - Smart commenting
- **nvim-autopairs** - Auto-close pairs
- **better-escape** - Fast escape with jk/jj
- **mini.ai** - Enhanced text objects
- **nvim-colorizer** - Color preview

### 13. **Utilities**
- **which-key** - Keybinding popup
- **persistence.nvim** - Session management
- **bufdelete.nvim** - Better buffer deletion
- **window-picker** - Easy window selection
- **vim-maximizer** - Toggle window maximize

## 🎯 Key Bindings

### Leader Key
- Leader: `<Space>`
- Local Leader: `\`

### File Navigation
- `<leader>e` - Toggle Neo-tree
- `<leader>E` - Focus Neo-tree
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Browse files
- `<leader>fo` - Old files
- `<leader>fp` - Projects
- `-` - Open Oil.nvim
- `<leader>1-5` - Harpoon files

### LSP
- `gd` - Go to definition
- `gr` - Go to references
- `gi` - Go to implementation
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>cr` - Rename
- `<leader>cf` - Format
- `<leader>cl` - Lint
- `[d` / `]d` - Previous/next diagnostic

### Git
- `<leader>gg` - LazyGit
- `<leader>gn` - Neogit
- `<leader>gd` - Diffview
- `<leader>gh` - File history
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `[c` / `]c` - Previous/next hunk

### Terminal
- `<C-\>` - Toggle terminal
- `<leader>tf` - Float terminal
- `<leader>th` - Horizontal terminal
- `<leader>tv` - Vertical terminal
- `<leader>tn` - Node REPL
- `<leader>tp` - Python REPL

### Diagnostics
- `<leader>xx` - Trouble diagnostics
- `<leader>xt` - Todo comments
- `<leader>cs` - Symbols outline
- `<leader>ca` - Aerial outline

### Navigation
- `s` - Flash jump
- `S` - Flash treesitter
- `<leader>sr` - Search & replace (Spectre)
- `<leader>ha` - Harpoon add
- `<leader>hh` - Harpoon menu

### AI/Copilot
- `<M-l>` - Accept Copilot suggestion
- `<leader>cce` - Copilot explain
- `<leader>cct` - Copilot tests
- `<leader>ccr` - Copilot review
- `<leader>ccf` - Copilot fix diagnostic

### Buffer/Window Management
- `<leader>bd` - Delete buffer
- `<leader>bp` - Pick buffer
- `<Tab>` / `<S-Tab>` - Next/previous buffer
- `<leader>wm` - Maximize window
- `<C-h/j/k/l>` - Navigate windows

## 🚀 Getting Started

### First Time Setup

1. **Install Dependencies:**
```bash
# On NixOS, most tools are likely already available
# For manual installation on other systems:
npm install -g prettier prettierd eslint_d
pip install black isort pylint
cargo install stylua
```

2. **Launch Neovim:**
```bash
nvim
```

3. **Install Plugins:**
Lazy.nvim will automatically install all plugins on first launch.

4. **Install LSP Servers & Tools:**
```vim
:MasonToolsInstall
```

5. **Health Check:**
```vim
:checkhealth
```

### Workflow Tips

1. **Project Setup:**
   - Open your project directory
   - Neo-tree will show file structure
   - Use `<leader>fp` to switch between projects

2. **Code Development:**
   - LSP provides autocomplete, go-to-definition, diagnostics
   - Use `<leader>cf` to format before saving
   - `<leader>ca` for code actions
   - Copilot suggests completions

3. **Git Workflow:**
   - `<leader>gg` opens LazyGit for staging/committing
   - Gitsigns shows changes in gutter
   - `<leader>gd` for visual diffs

4. **Search & Navigation:**
   - `<leader>ff` for fuzzy file search
   - `<leader>fg` for text search
   - `s` for flash navigation
   - `<leader>sr` for project-wide replace

5. **Diagnostics:**
   - `<leader>xx` shows all diagnostics
   - `<leader>xt` lists TODOs
   - `[d` / `]d` navigate diagnostics

## 📝 Customization

### Format on Save
Format on save is enabled by default. To disable:
```vim
:FormatDisable      " Disable for current buffer
:FormatDisable!     " Disable for all buffers
:FormatEnable       " Re-enable
```

### Theme Customization
Edit `lua/plugins/ui.lua` to modify TokyoNight settings.

### Add Language Server
Edit `lua/plugins/lsp.lua` and add to mason_lspconfig servers list.

### Add Formatter
Edit `lua/plugins/formatting.lua` and add to formatters_by_ft table.

### Custom Keymaps
Add to `lua/core/keymaps.lua` or individual plugin configs.

## 🔧 Configuration Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── core/
│   │   ├── options.lua        # Vim options
│   │   ├── keymaps.lua        # Global keymaps
│   │   ├── autocmds.lua       # Autocommands
│   │   ├── lazy.lua           # Lazy.nvim setup
│   │   ├── utils.lua          # Utility functions
│   │   └── icons.lua          # Icon definitions
│   └── plugins/
│       ├── init.lua           # Core plugins
│       ├── ui.lua             # UI plugins
│       ├── lsp.lua            # LSP configuration
│       ├── treesitter.lua     # Treesitter config
│       ├── completion.lua     # Completion & AI
│       ├── file-explorer.lua  # File navigation
│       ├── terminal.lua       # Terminal & git
│       ├── diagnostics.lua    # Diagnostics tools
│       ├── formatting.lua     # Formatting & linting
│       ├── navigation.lua     # Navigation tools
│       └── telescope.lua      # Telescope config
```

## 🎨 Features Highlight

### Intelligent Code Completion
- Context-aware suggestions
- Snippet expansion
- LSP-powered completions
- AI-assisted with Copilot
- Function signatures

### Advanced Git Integration
- Visual diff viewing
- Interactive staging
- Commit history browsing
- Merge conflict resolution
- Blame annotations

### Powerful Search & Replace
- Fuzzy file finder
- Live grep with preview
- Project-wide search & replace
- Smart case sensitivity
- Regex support

### Code Quality Tools
- Real-time diagnostics
- Linting on save
- Format on save
- TODO tracking
- Symbol navigation

### Terminal Integration
- Floating terminals
- Multiple terminal layouts
- LazyGit integration
- REPL support
- Easy navigation

## 🐛 Troubleshooting

### LSP Not Working
```vim
:LspInfo              " Check LSP status
:Mason                " Verify servers installed
:checkhealth lsp      " Run health check
```

### Treesitter Issues
```vim
:TSUpdate             " Update parsers
:TSInstallInfo        " Check installed parsers
:checkhealth treesitter
```

### Formatting Not Working
```vim
:ConformInfo          " Check formatter status
:Mason                " Verify formatters installed
```

### Python Provider Error
The Python provider error you saw is optional and doesn't affect core functionality. To fix it:
```bash
python -m venv ~/.venvs/nvim
~/.venvs/nvim/bin/pip install pynvim
```

## 📚 Learning Resources

- **Which-key**: Press `<Space>` and wait to see available keybindings
- **Help System**: `:help <plugin-name>` for any plugin
- **Telescope Help**: `<leader>fh` to search help tags
- **Keymaps**: `<leader>fk` to search keymaps

## ✨ What Makes This IDE Special

1. **Modern Architecture** - Uses latest Neovim APIs and Lua
2. **Fast Startup** - Lazy loading optimizes performance
3. **Language Agnostic** - Support for 40+ languages
4. **AI-Powered** - GitHub Copilot integration
5. **Git-Centric** - Comprehensive git workflow
6. **Extensible** - Easy to add new plugins and features
7. **Well-Organized** - Clean structure, easy to navigate
8. **Beautiful UI** - Modern
