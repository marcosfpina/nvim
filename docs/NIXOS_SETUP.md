# NixOS Setup Guide for Neovim Telescope Configuration

## Quick Start

This guide provides NixOS-specific instructions for setting up the Telescope configuration.

## Required System Packages

### Option 1: System-wide (configuration.nix)

Add to `/etc/nixos/configuration.nix`:

```nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Essential for Telescope
    ripgrep                    # Required: Live grep functionality
    fd                         # Recommended: Fast file finding
    gnumake                    # Required: Build telescope-fzf-native
    gcc                        # Required: Compile native extensions
    
    # Recommended for full functionality
    tree-sitter                # Syntax parsing
    sqlite                     # Frecency database
    git                        # Version control
    nodejs_20                  # LSP servers
    
    # Optional but useful
    lazygit                    # Git UI
    delta                      # Better git diffs
  ];
}
```

Then rebuild:
```bash
sudo nixos-rebuild switch
```

### Option 2: Home Manager (home.nix)

Add to `~/.config/home-manager/home.nix`:

```nix
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fd
    gnumake
    gcc
    tree-sitter
    sqlite
    nodejs_20
  ];
}
```

Then rebuild:
```bash
home-manager switch
```

## Installation Steps

1. **Ensure system packages are installed** (see above)

2. **Open Neovim**:
   ```bash
   nvim
   ```

3. **Lazy.nvim will detect new plugins**:
   - You'll see a notification about new plugins
   - Press any key to continue, or wait for auto-installation

4. **Manually sync (if needed)**:
   ```vim
   :Lazy sync
   ```

5. **Verify installation**:
   ```vim
   :Lazy
   ```
   Look for telescope and all extensions (should show as installed)

6. **Test Telescope**:
   ```vim
   :Telescope find_files
   ```
   Or use keymap: `<leader>ff`

## Verifying Dependencies

### Check if tools are available:
```bash
# Should show version numbers
rg --version
fd --version
make --version
gcc --version
```

### Check Telescope extensions:
```vim
:Telescope
```
Then type to filter and see all available pickers.

## Building Native Extensions

The telescope-fzf-native extension should build automatically when you run `:Lazy sync`.

If it fails, manually build:
```bash
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
make
```

## Troubleshooting

### Issue: "rg: command not found"
**Solution**: Install ripgrep via nix:
```bash
nix profile install nixpkgs#ripgrep
```

### Issue: "make: command not found"
**Solution**: Install gnumake:
```bash
nix profile install nixpkgs#gnumake nixpkgs#gcc
```

### Issue: FZF native not building
**Solution**: 
1. Check if make and gcc are installed
2. Manually build:
   ```bash
   cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
   make clean && make
   ```

### Issue: SQLite errors with frecency
**Solution**: Install sqlite:
```bash
nix profile install nixpkgs#sqlite
```

### Issue: No icons showing
**Solution**: Install a Nerd Font:
```nix
# In configuration.nix
fonts.packages = with pkgs; [
  (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Hack" ]; })
];
```

## Telescope Extensions Installed

✅ **telescope-fzf-native.nvim** - Fast native sorter  
✅ **telescope-file-browser.nvim** - File system browser  
✅ **telescope-ui-select.nvim** - Better vim.ui.select  
✅ **telescope-live-grep-args.nvim** - Advanced grep  
✅ **telescope-project.nvim** - Project management  
✅ **telescope-frecency.nvim** - Smart file history  
✅ **telescope-undo.nvim** - Visual undo tree  
✅ **telescope-symbols.nvim** - Emoji & symbols  
✅ **trouble.nvim** - Enhanced diagnostics  

## Key Bindings Quick Reference

### File Operations
- `<leader>ff` - Find files
- `<leader>fr` - Recent files
- `<leader>fb` - List buffers
- `<leader>fn` - File browser

### Search
- `<leader>fg` - Live grep
- `<leader>fw` - Grep word under cursor
- `<leader>fG` - Live grep with args

### LSP
- `<leader>fd` - Document diagnostics
- `<leader>fl` - Document symbols
- `gr` - LSP references

### Git
- `<leader>gc` - Git commits
- `<leader>gS` - Git status
- `<leader>gB` - Git branches

### Extensions
- `<leader>fp` - Projects
- `<leader>fF` - Frecency
- `<leader>fu` - Undo tree
- `<leader>fe` - Emoji & symbols

### Utilities
- `<leader>fh` - Help tags
- `<leader>fk` - View all keymaps
- `<leader>f.` - Resume last picker

## Testing Your Setup

Run these commands to verify everything works:

```vim
" File finding
:Telescope find_files

" Live grep (requires ripgrep)
:Telescope live_grep

" Projects
:Telescope project

" Frecency (smart file history)
:Telescope frecency

" Undo tree
:Telescope undo

" View all Telescope pickers
:Telescope
```

## Next Steps

1. ✅ Install system packages
2. ✅ Open Neovim and sync plugins
3. ✅ Test basic Telescope functionality
4. 📖 Read TELESCOPE_UPGRADE.md for full documentation
5. 🎯 Explore keybindings with `<leader>fk`
6. 💡 Try frecency - it learns your file access patterns
7. 🎨 Customize workspaces in `lua/plugins/telescope.lua`

## Resources

- **Configuration File**: `~/.config/nvim/lua/plugins/telescope.lua`
- **Full Documentation**: `~/.config/nvim/TELESCOPE_UPGRADE.md`
- **NixOS Packages**: https://search.nixos.org/packages
- **Telescope Docs**: https://github.com/nvim-telescope/telescope.nvim

## Support

If you encounter issues:
1. Check `:checkhealth telescope`
2. View `:Lazy` for plugin status
3. Check `:messages` for error messages
4. Review `TELESCOPE_UPGRADE.md` troubleshooting section

---

**Last Updated**: January 2, 2025  
**System**: NixOS with Home Manager support  
**Status**: ✅ Production Ready
