# Next Steps - Telescope Upgrade Guide

## 🎯 Getting Started with Your New Telescope Setup

Congratulations! You've upgraded your Neovim configuration with powerful Telescope extensions. This guide will help you get the most out of your new setup.

---

## 📋 Step 1: Install Dependencies (NixOS)

### Choose Your Installation Method

**Recommended: System-wide installation**
```bash
# Edit your configuration
sudo nano /etc/nixos/configuration.nix
```

Add these packages:
```nix
environment.systemPackages = with pkgs; [
  ripgrep     # Required
  fd          # Recommended
  gnumake     # Required
  gcc         # Required
  sqlite      # Optional
];
```

Apply changes:
```bash
sudo nixos-rebuild switch
```

**Alternative: Home Manager**
See `NIXOS_SETUP.md` for detailed instructions.

---

## 🚀 Step 2: Install Telescope Plugins

1. **Open Neovim**:
   ```bash
   nvim
   ```

2. **Sync plugins**:
   ```vim
   :Lazy sync
   ```
   
3. **Wait for installation** - This may take 1-2 minutes
   - Native extensions will build automatically
   - Watch for any error messages

4. **Restart Neovim**:
   ```vim
   :qa
   ```

---

## ✅ Step 3: Verify Installation

### Test Basic Functionality

Open Neovim and try these commands:

```vim
" 1. Find files (should show file picker)
:Telescope find_files

" 2. Live grep (should search across files)
:Telescope live_grep

" 3. Check installed extensions
:Telescope

" 4. View plugin status
:Lazy
```

### Quick Test Checklist
- [ ] `:Telescope find_files` works
- [ ] `:Telescope live_grep` works
- [ ] Icons display correctly
- [ ] No error messages in `:messages`

---

## 📚 Step 4: Learn the Essential Keybindings

### Start with These 5 Most Important Commands

1. **`<leader>ff`** - Find files (your new best friend)
2. **`<leader>fg`** - Search text across all files
3. **`<leader>fb`** - Switch between open buffers
4. **`<leader>fr`** - Recent files (quick file access)
5. **`<leader>fk`** - View all keymaps (your cheat sheet!)

### Practice Exercise (5 minutes)

1. Press `<leader>ff` to find files
2. Type part of a filename and press Enter
3. Press `<leader>fg` to search for text
4. Type "function" and see all functions
5. Press `<leader>fk` to see all available keymaps

---

## 🎓 Step 5: Master Telescope Navigation

### Inside Any Telescope Picker

**Insert Mode** (default when you open a picker):
- `<C-j>` or `<C-n>` - Move down
- `<C-k>` or `<C-p>` - Move up
- `<C-h>` - Toggle preview window
- `<CR>` - Open file/select item
- `<C-x>` - Open in horizontal split
- `<C-v>` - Open in vertical split
- `<Esc>` - Close picker

**Pro Tips**:
- Start typing to filter results
- Use fuzzy matching (e.g., "fnf" finds "find_files")
- Press `?` in normal mode to see all keybindings

### Practice Exercise (5 minutes)

1. Open `<leader>ff`
2. Press `<C-h>` to toggle preview
3. Navigate with `<C-j>` and `<C-k>`
4. Try opening a file with `<C-v>` (vertical split)
5. Press `?` to see help

---

## 🔥 Step 6: Explore Powerful Features

### Day 1-2: Core Features

**File Finding & Search**
```vim
<leader>ff    " Find files - your go-to command
<leader>fg    " Search in files (live grep)
<leader>fw    " Search word under cursor
<leader>fr    " Recent files
```

**Try This Now**: 
1. Press `<leader>ff`
2. Type a filename
3. Press `<leader>fg`
4. Search for "telescope"

### Day 3-4: LSP Integration

**LSP Navigation**
```vim
gr            " Find references (where is this used?)
gI            " Find implementations
gt            " Go to type definition
<leader>fd    " Show diagnostics (errors/warnings)
<leader>fl    " Document symbols (outline)
```

**Try This Now**:
1. Open a code file
2. Put cursor on a function name
3. Press `gr` to see all references

### Day 5-7: Advanced Features

**Project Management**
```vim
<leader>fp    " Switch projects
<leader>fF    " Frecency (smart file history)
```

**Git Integration**
```vim
<leader>gc    " Browse git commits
<leader>gS    " Git status
<leader>gB    " Switch branches
```

**Undo Tree**
```vim
<leader>fu    " Visual undo tree (time travel!)
```

**Try This Now**:
1. Make some edits to a file
2. Press `<leader>fu`
3. Navigate your undo history visually

---

## 💡 Step 7: Customize Your Workflow

### Configure Frecency Workspaces

Edit `~/.config/nvim/lua/plugins/telescope.lua`:

```lua
frecency = {
  workspaces = {
    ["conf"] = vim.fn.expand("~/.config"),
    ["nvim"] = vim.fn.expand("~/.config/nvim"),
    ["projects"] = vim.fn.expand("~/projects"),
    -- Add your own:
    ["work"] = vim.fn.expand("~/work"),
    ["notes"] = vim.fn.expand("~/Documents/notes"),
  },
}
```

### Configure Project Directories

```lua
project = {
  base_dirs = {
    "~/projects",
    "~/.config",
    -- Add your own:
    "~/work",
    "~/repos",
  },
}
```

---

## 🎯 Step 8: Build Your Muscle Memory (Week 1)

### Daily Practice Routine (5-10 minutes/day)

**Monday: File Navigation**
- Use only `<leader>ff` for opening files
- Try `<leader>fr` for recent files
- Goal: Stop using `:e` or file explorer

**Tuesday: Search**
- Use `<leader>fg` instead of grep
- Try `<leader>fw` for word search
- Goal: Fast project-wide searching

**Wednesday: Buffers & Windows**
- Use `<leader>fb` to switch buffers
- Try `<C-x>` and `<C-v>` splits
- Goal: Efficient buffer management

**Thursday: LSP Navigation**
- Use `gr` for references
- Try `<leader>fl` for symbols
- Goal: Navigate code without file tree

**Friday: Git Workflow**
- Use `<leader>gc` for commits
- Try `<leader>gS` for status
- Goal: Git workflow in editor

**Weekend: Advanced Features**
- Try `<leader>fp` for projects
- Explore `<leader>fu` for undo
- Try `<leader>fF` for frecency

---

## 📈 Step 9: Track Your Progress

### Week 1 Goals
- [ ] Use `<leader>ff` as primary file opener
- [ ] Use `<leader>fg` for all text searches
- [ ] Use `<leader>fb` for buffer switching
- [ ] Try `gr` for code navigation
- [ ] Explore one git command

### Week 2 Goals
- [ ] Use LSP navigation daily
- [ ] Set up custom workspaces
- [ ] Use project switcher
- [ ] Master split opening with `<C-x>`/`<C-v>`
- [ ] Try undo tree visualization

### Month 1 Goals
- [ ] Telescope is your default for everything
- [ ] Rarely use file explorer
- [ ] Custom workspaces configured
- [ ] Comfortable with all git commands
- [ ] Teaching others Telescope tricks

---

## 🔧 Step 10: Troubleshooting & Help

### If Something Doesn't Work

1. **Check dependencies**:
   ```bash
   rg --version
   fd --version
   make --version
   ```

2. **Check Telescope health**:
   ```vim
   :checkhealth telescope
   ```

3. **View error messages**:
   ```vim
   :messages
   ```

4. **Check plugin status**:
   ```vim
   :Lazy
   ```

5. **Read detailed docs**:
   - `TELESCOPE_UPGRADE.md` - Complete documentation
   - `NIXOS_SETUP.md` - NixOS-specific help

### Common Issues

**Issue**: "No such command: Telescope"
- **Fix**: Run `:Lazy sync` and restart Neovim

**Issue**: Live grep not working
- **Fix**: Install ripgrep: `nix profile install nixpkgs#ripgrep`

**Issue**: FZF native errors
- **Fix**: Install make and gcc, then rebuild native extension

---

## 🎁 Bonus: Hidden Gems

### Features You'll Love After Week 2

1. **Emoji Picker**: `<leader>fe` - Insert emojis/symbols
2. **Command History**: `<leader>f:` - Search command history
3. **Registers**: `<leader>fR` - View and select from registers
4. **Marks**: `<leader>fm` - Jump to marks visually
5. **Resume**: `<leader>f.` - Resume last picker (super useful!)

### Power User Tricks

**Live Grep with Arguments**:
```vim
<leader>fG
" Then: <C-k> to quote your search
" Add: --iglob to search specific files
```

**Multiple File Selection**:
- `<Tab>` - Select multiple files
- `<C-q>` - Send to quickfix list
- Work on all selected files at once

**Frecency Smart History**:
- `<leader>fF` learns what you access
- Files you use often appear first
- Weighted by frequency + recency

---

## 📅 Your 30-Day Roadmap

### Week 1: Foundation
- Install and verify setup
- Learn 5 essential keybindings
- Use Telescope for file opening

### Week 2: Expansion
- Add LSP navigation
- Try git commands
- Explore advanced features

### Week 3: Optimization
- Customize workspaces
- Fine-tune keybindings
- Build muscle memory

### Week 4: Mastery
- Use Telescope for everything
- Teach others your workflow
- Contribute customizations

---

## 🎓 Learning Resources

### Built-in Help
```vim
:help telescope
:help telescope-mappings
:Telescope help_tags     " Search all help topics
```

### Key Reference
```vim
<leader>fk               " View all keymaps anytime
<leader>fh               " Search help tags
```

### Documentation Files
- **TELESCOPE_UPGRADE.md** - Complete feature reference
- **NIXOS_SETUP.md** - Installation and troubleshooting
- **CLAUDE.md** - Architecture overview

---

## 🚀 You're Ready!

Start with Step 1 and work through each step at your own pace. Focus on building muscle memory with the essential keybindings before moving to advanced features.

**Remember**: 
- Use `<leader>fk` anytime to see all keybindings
- Use `:Telescope` to explore available pickers
- Practice daily for best results

**Happy exploring! 🎉**

---

## Quick Reference Card

```
ESSENTIAL KEYBINDINGS (Print or bookmark this!)

Files              Search             LSP                Git
────────────────   ────────────────   ────────────────   ────────────────
<leader>ff  Files  <leader>fg  Grep   gr  References     <leader>gc  Commits
<leader>fr  Recent <leader>fw  Word   gI  Implements     <leader>gS  Status  
<leader>fb  Buffers<leader>fs  Buffer gt  Type def       <leader>gB  Branches
<leader>fn  Browse <leader>fG  Args   <leader>fd  Diag   <leader>gt  Stash

Extensions         Utilities          Help
────────────────   ────────────────   ────────────────
<leader>fp  Projects <leader>fu  Undo   <leader>fk  Keymaps
<leader>fF  Frecency <leader>fe  Emoji  <leader>fh  Help
<leader>f.  Resume   <leader>fm  Marks  ?  Show bindings
```

---

**Last Updated**: January 2, 2025  
**Status**: Ready to start your Telescope journey! 🚀
