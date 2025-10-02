# Telescope Configuration Upgrade

## Summary

Successfully upgraded Telescope and related plugins with modern extensions and comprehensive keybindings for an enhanced development workflow.

## What Was Added

### New File Created
- **`lua/plugins/telescope.lua`** - Complete Telescope configuration with all extensions and keybindings

### Core Plugin
- **telescope.nvim** - Latest version with lazy loading on command

### Extensions Installed

1. **telescope-fzf-native.nvim** - Native FZF sorter for better performance (requires `make`)
2. **telescope-file-browser.nvim** - File system browser with create/delete capabilities
3. **telescope-ui-select.nvim** - Better `vim.ui.select` interface
4. **telescope-live-grep-args.nvim** - Advanced grep with arguments support
5. **telescope-project.nvim** - Project management and quick switching
6. **telescope-frecency.nvim** - Smart file sorting based on frequency and recency
7. **telescope-undo.nvim** - Visual undo tree browser
8. **telescope-symbols.nvim** - Emoji and symbols picker

### Additional Integration
- **trouble.nvim** - Better diagnostics viewer integrated with Telescope

## Key Bindings

### File Operations
- `<leader>ff` - Find files
- `<leader>fr` - Recent files
- `<leader>fb` - List buffers
- `<leader>fc` - Find config files
- `<leader>fn` - File browser
- `<leader>fN` - File browser (current directory)

### Search Operations
- `<leader>fg` - Live grep
- `<leader>fw` - Grep word under cursor
- `<leader>fG` - Live grep with args
- `<leader>fs` - Search in current buffer

### LSP Integration
- `<leader>fd` - Document diagnostics
- `<leader>fD` - Workspace diagnostics
- `<leader>fl` - Document symbols
- `<leader>fL` - Workspace symbols
- `gr` - LSP references (overrides default)
- `gI` - LSP implementations
- `gt` - LSP type definitions

### Git Integration
- `<leader>gc` - Git commits
- `<leader>gC` - Git buffer commits
- `<leader>gB` - Git branches
- `<leader>gS` - Git status
- `<leader>gt` - Git stash

### Vim Utilities
- `<leader>fh` - Help tags
- `<leader>fk` - Keymaps
- `<leader>fm` - Marks
- `<leader>fj` - Jumplist
- `<leader>fR` - Registers
- `<leader>fo` - Vim options
- `<leader>fa` - Autocommands
- `<leader>fH` - Highlights
- `<leader>fC` - Commands
- `<leader>f:` - Command history
- `<leader>f/` - Search history

### Extensions
- `<leader>fp` - Projects
- `<leader>fF` - Frecency (smart file history)
- `<leader>fu` - Undo tree
- `<leader>fe` - Emoji & symbols

### Misc
- `<leader>f.` - Resume last picker
- `<leader><leader>` - Switch buffer
- `<leader>,` - Switch buffer

### Trouble Integration
- `<leader>xx` - Diagnostics (Trouble)
- `<leader>xX` - Buffer diagnostics (Trouble)
- `<leader>xs` - Symbols (Trouble)
- `<leader>xl` - LSP definitions/references (Trouble)
- `<leader>xL` - Location list (Trouble)
- `<leader>xQ` - Quickfix list (Trouble)

## Telescope Mappings (Inside Picker)

### Insert Mode
- `<C-n>/<C-j>` - Next item
- `<C-p>/<C-k>` - Previous item
- `<C-u>` - Preview scroll up
- `<C-d>` - Preview scroll down
- `<C-h>` - Toggle preview
- `<C-s>` - Send to Trouble
- `<C-q>` - Send to quickfix
- `<Tab>` - Toggle selection + move down
- `<S-Tab>` - Toggle selection + move up
- `<C-x>` - Open in horizontal split
- `<C-v>` - Open in vertical split
- `<C-t>` - Open in new tab

### Normal Mode
- `j/k` - Navigate items
- `H/M/L` - Move to top/middle/bottom
- `gg/G` - Move to first/last
- `?` - Show key bindings help
- `dd` (in buffers) - Delete buffer

## Features

### Performance Optimizations
- FZF native sorter for faster filtering
- Lazy loading on command
- Smart file ignore patterns (node_modules, .git, etc.)
- Hidden file support with ripgrep

### UI Enhancements
- Horizontal layout with top prompt
- Preview window with smart width
- Custom icons and colors
- Smooth animations via mini.animate

### Smart Features
- Frecency-based file sorting (learns your patterns)
- Project-aware file searching
- Undo tree visualization
- Live grep with custom arguments
- Multi-selection support
- Quickfix integration

### LSP Integration
- Symbol search with treesitter
- Diagnostics viewer
- References and implementations
- Type definitions
- Seamless integration with Trouble.nvim

### Git Features
- Commit browsing
- Branch management
- Status viewer
- Stash management
- Buffer-specific commits

## Configuration Highlights

### Ignored Files
```lua
"node_modules", "%.git/", "%.cache", "%.o", "%.a", "%.out",
"%.class", "%.pdf", "%.mkv", "%.mp4", "%.zip", "%.tar.gz"
```

### Ripgrep Integration
- Smart case search
- Hidden files included
- Git files excluded by default
- Line and column numbers
- Context-aware results

### Frecency Workspaces
- `conf` → `~/.config`
- `nvim` → `~/.config/nvim`
- `projects` → `~/projects`

## Changes to Existing Files

### lua/cmd.lua
- Removed duplicate Telescope keymaps (now in lua/plugins/telescope.lua)
- Added comment noting new location
- Preserved all other functionality

## Installation Instructions

1. **Open Neovim**: Just start nvim normally
   ```bash
   nvim
   ```

2. **Lazy.nvim will automatically detect new plugins** and show a notification

3. **Install new plugins**: Press any key when prompted, or manually run:
   - `:Lazy sync` to install all new plugins
   - `:Lazy update` to update existing ones

4. **Verify installation**: Run `:Lazy` to see plugin status

5. **Build FZF native** (for better performance):
   ```bash
   cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim && make
   ```
   Or just let Lazy handle it automatically.

## Dependencies

### Required for NixOS
- **ripgrep** (`rg`) - For live grep functionality
- **fd** - Faster file finding (highly recommended)
- **gnumake** - For building telescope-fzf-native

### NixOS Installation (Recommended Methods)

#### Option 1: Add to configuration.nix (System-wide)
```nix
# /etc/nixos/configuration.nix
environment.systemPackages = with pkgs; [
  ripgrep
  fd
  gnumake
  gcc  # Required for building native extensions
  # Optional but recommended
  tree-sitter
  sqlite
];
```

Then rebuild:
```bash
sudo nixos-rebuild switch
```

#### Option 2: Home Manager (User-specific)
```nix
# ~/.config/home-manager/home.nix
home.packages = with pkgs; [
  ripgrep
  fd
  gnumake
  gcc
];
```

Then rebuild:
```bash
home-manager switch
```

#### Option 3: Nix Shell (Temporary)
```bash
nix-shell -p ripgrep fd gnumake gcc
```

#### Option 4: Nix Profile (User-specific, persistent)
```bash
nix profile install nixpkgs#ripgrep nixpkgs#fd nixpkgs#gnumake nixpkgs#gcc
```

### Install Dependencies (Other Systems)
```bash
# Ubuntu/Debian
sudo apt install ripgrep fd-find build-essential

# Fedora
sudo dnf install ripgrep fd-find make

# Arch
sudo pacman -S ripgrep fd make

# macOS
brew install ripgrep fd make
```

## Testing

After installation, test these commands:
- `:Telescope find_files` - Should show file picker
- `:Telescope live_grep` - Should search across files
- `:Telescope project` - Should show projects
- `<leader>ff` - Should trigger file finder
- `<leader>fu` - Should show undo tree

## Troubleshooting

### FZF Native Not Building
If the native extension fails to build:
```bash
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
make
```

### SQLite Issues (Frecency)
If frecency extension has issues:
```bash
# Install sqlite.lua dependencies
# Usually handled automatically by Lazy
```

### Missing Icons
Ensure you have a Nerd Font installed and configured in your terminal.

## Benefits

1. **Performance**: FZF native sorter provides blazing fast filtering
2. **Productivity**: Comprehensive keybindings for common operations
3. **Smart Search**: Frecency learns your file access patterns
4. **Git Integration**: Full git workflow from within editor
5. **LSP Power**: Quick access to symbols, references, diagnostics
6. **Visual Tools**: Undo tree and file browser for better file management
7. **Extensible**: Easy to add more Telescope extensions as needed

## Next Steps

1. Install the plugins via `:Lazy sync`
2. Explore the new keybindings (press `<leader>fk` to see all keymaps)
3. Try the frecency picker (`<leader>fF`) - it learns over time
4. Experiment with live grep args (`<leader>fG`) for advanced search
5. Use the undo tree (`<leader>fu`) for visual undo/redo

## Resources

- [Telescope Documentation](https://github.com/nvim-telescope/telescope.nvim)
- [Telescope Extensions](https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions)
- [Trouble.nvim](https://github.com/folke/trouble.nvim)

---

**Configuration Date**: January 2, 2025  
**Status**: ✅ Ready for production use
