# Neovim Configuration: Diagnostic, Debugging & Flake Migration

**Repository**: https://github.com/VoidNxSEC/nvim  
**Author**: VoidNxSEC  
**Last Updated**: 2025-01-07  
**Status**: Active Development

## 📋 Table of Contents

1. [Overview](#overview)
2. [Phase 1: Diagnostics](#phase-1-diagnostics)
3. [Phase 2: Decouple from Nix Store](#phase-2-decouple-from-nix-store)
4. [Phase 3: Fix lazy.nvim](#phase-3-fix-lazynvim)
5. [Phase 4: Create Standalone Flake](#phase-4-create-standalone-flake)
6. [Phase 5: System Integration](#phase-5-system-integration)
7. [Validation & Testing](#validation--testing)
8. [Troubleshooting](#troubleshooting)

---

## Overview

### Current Situation

- Neovim configuration embedded in `nixos/home.nix` via `.text`
- `lazy.nvim` plugin manager has error handling that masks failures
- Configuration deployed via `nixos-rebuild switch --flake`
- Need to decouple for iterative development

### Goals

1. **Decouple** Neovim from Nix store for rapid iteration
2. **Debug & Fix** lazy.nvim error handling
3. **Create** standalone flake for portability
4. **Integrate** back into main system flake
5. **Ensure** all functionality works correctly

---

## Phase 1: Diagnostics

### 1.1 Check Current State

**Run these commands inside Neovim:**

```vim
" Check configuration status
:NvimConfigStatus

" Check health
:checkhealth

" Check lazy.nvim specifically
:checkhealth lazy

" View errors
:lua print(vim.inspect(_G.nvim_config.state.errors))

" View warnings
:lua print(vim.inspect(_G.nvim_config.state.warnings))

" Check if lazy is loaded
:lua print(pcall(require, "lazy"))
```

### 1.2 Verify System Dependencies

**Check if required tools are available:**

```bash
# Essential for Telescope and plugin compilation
which ripgrep  # Required for live grep
which fd       # Fast file finding
which gcc      # Compile native extensions
which make     # Build telescope-fzf-native
which git      # Version control

# Check Neovim version
nvim --version

# Check if lazy.nvim is installed
ls -la ~/.local/share/nvim/lazy/

# Check if plugins directory exists
ls -la ~/.config/nvim/lua/plugins/
```

### 1.3 Check File Ownership & Permissions

```bash
# Check if config is symlink or real file
ls -la ~/.config/nvim/

# Check ownership (should be user, not root)
stat ~/.config/nvim/init.lua

# Check if writable
test -w ~/.config/nvim/init.lua && echo "Writable" || echo "Read-only"

# Check Nix store involvement
readlink -f ~/.config/nvim/init.lua
```

### 1.4 Enable Debug Mode

**Temporarily enable verbose logging:**

```bash
# Set environment variable before starting nvim
NVIM_DEV_MODE=1 nvim
```

**Inside Neovim, check detailed logs:**

```vim
:lua print(vim.inspect(_G.nvim_config.metrics.module_load_times))
:messages
```

### 1.5 Manual lazy.nvim Test

**Test lazy.nvim loading manually:**

```lua
-- In Neovim command mode
:lua local ok, lazy = pcall(require, "lazy"); print("Lazy loaded:", ok, lazy)

-- Check lazy path
:lua print(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

-- Check if path exists
:lua print(vim.loop.fs_stat(vim.fn.stdpath("data") .. "/lazy/lazy.nvim"))
```

### 1.6 Expected Output

**Healthy System:**
- `:checkhealth` shows no critical errors
- `lazy.nvim` is found and loaded
- Plugins are loaded successfully
- No fatal errors in `_G.nvim_config.state.errors`

**Problem Indicators:**
- "Lazy.nvim not available" warnings
- Empty plugin list in `:Lazy`
- Fallback utilities being used
- Read-only file system errors
- Missing system dependencies

---

## Phase 2: Decouple from Nix Store

### 2.1 Current Problem

**In `nixos/home.nix`:**
```nix
home.file = {
  ".config/nvim/init.lua".text = ''
    # Embedded init.lua content here...
  '';
};
```

**Issues:**
- Every `nixos-rebuild` overwrites the file
- No way to edit and test quickly
- Files are read-only in Nix store
- Git repository is not used directly

### 2.2 Solution: Use Symlink

**Modify `nixos/home.nix`:**

**Option A: Direct Source (Recommended)**
```nix
home.file = {
  # Remove the embedded init.lua
  # ".config/nvim/init.lua".text = ''...'';  # DELETE THIS
  
  # Instead, symlink to your git repo
  ".config/nvim" = {
    source = /home/kernelcore/.config/nvim;
    recursive = true;
  };
};
```

**Option B: Explicit Symlink**
```nix
home.file = {
  ".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/.config/nvim";
  };
};
```

**Option C: XDG Directory**
```nix
xdg.configFile = {
  "nvim" = {
    source = /home/kernelcore/.config/nvim;
    recursive = true;
  };
};
```

### 2.3 Implementation Steps

**Step 1: Backup Current Config**
```bash
# Backup embedded config
cp ~/.config/nvim/init.lua ~/nvim-init-backup.lua

# Check if git repo exists
cd ~/.config/nvim
git status
```

**Step 2: Modify home.nix**
```bash
# Edit home.nix
nvim ~/nixos/home.nix

# Remove or comment out the embedded init.lua section
# Add one of the options above
```

**Step 3: Apply Changes**
```bash
# Rebuild system
sudo nixos-rebuild switch --flake /etc/nixos#kernelcore --show-trace

# Or if you have it setup differently
sudo nixos-rebuild switch --flake ~/nixos#kernelcore
```

**Step 4: Verify Symlink**
```bash
# Check if it's now a symlink
ls -la ~/.config/nvim/

# Should show something like:
# lrwxrwxrwx ... nvim -> /home/kernelcore/.config/nvim

# Or check realpath
realpath ~/.config/nvim/init.lua
# Should NOT be in /nix/store/
```

**Step 5: Test Editability**
```bash
# Try editing a file
touch ~/.config/nvim/test.txt
rm ~/.config/nvim/test.txt

# If this works, you're decoupled!
```

### 2.4 Benefits After Decoupling

✅ **Instant iteration**: Edit files and `:source %` to test  
✅ **Git integration**: Direct commits and pulls  
✅ **Plugin management**: lazy.nvim can write to disk  
✅ **No rebuilds**: System rebuild only for dependencies  
✅ **Development workflow**: Standard editor development

---

## Phase 3: Fix lazy.nvim

### 3.1 Current Issues

**In `lua/core/lazy.lua`:**
- Multiple `pcall()` with silent failures
- Early `return` statements mask errors
- Insufficient logging of failure causes
- Hard to debug what's actually failing

**In `init.lua`:**
- Error handling too permissive
- Fallback modes hide real problems
- Users don't know plugins aren't loading

### 3.2 Enhanced lazy.lua

**Create improved version with detailed logging:**

```lua
-- lua/core/lazy.lua
-- Enhanced lazy.nvim setup with comprehensive logging

-- Detect environment
local is_nixos = vim.fn.executable("nix") == 1 or vim.env.NIX_PATH ~= nil
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

_G.log.info("=== LAZY.NVIM INITIALIZATION ===")
_G.log.debug("NixOS detected: " .. tostring(is_nixos))
_G.log.debug("Lazy path: " .. lazypath)

-- Check if lazy.nvim exists
local lazy_exists = vim.loop.fs_stat(lazypath)
_G.log.debug("Lazy exists at path: " .. tostring(lazy_exists ~= nil))

if lazy_exists then
  _G.log.info("Found lazy.nvim at: " .. lazypath)
  vim.opt.rtp:prepend(lazypath)
else
  _G.log.warn("Lazy.nvim not found at standard path")
  
  -- Try to find in system (NixOS)
  local system_lazy = vim.fn.exepath("lazy.nvim")
  if system_lazy ~= "" then
    _G.log.info("Found system lazy.nvim at: " .. system_lazy)
  else
    if is_nixos then
      _G.log.error("Lazy.nvim not found. On NixOS, consider installing via home-manager or system config")
      _G.log.error("Or run: nix-shell -p git --run 'git clone https://github.com/folke/lazy.nvim.git " .. lazypath .. "'")
    else
      _G.log.warn("Attempting to bootstrap lazy.nvim...")
      local success = pcall(function()
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable",
          lazypath,
        })
      end)
      
      if success then
        _G.log.info("Successfully cloned lazy.nvim")
        vim.opt.rtp:prepend(lazypath)
      else
        _G.log.error("Failed to clone lazy.nvim")
        return false
      end
    end
  end
end

-- Attempt to load lazy
local lazy_ok, lazy = pcall(require, "lazy")

if not lazy_ok then
  _G.log.error("Failed to require lazy.nvim: " .. tostring(lazy))
  _G.log.error("Please install lazy.nvim manually")
  
  -- Show error to user
  vim.notify(
    "Lazy.nvim failed to load!\n\nError: " .. tostring(lazy) .. "\n\nCheck :NvimConfigStatus for details",
    vim.log.levels.ERROR,
    { title = "Plugin Manager Error", timeout = 10000 }
  )
  
  return false
end

_G.log.info("✓ Lazy.nvim loaded successfully")

-- Setup with error handling
local setup_ok, setup_err = pcall(function()
  lazy.setup({
    { import = "plugins" },
  }, {
    defaults = {
      lazy = true,
      version = false,
    },
    
    install = {
      missing = true,
      colorscheme = { "tokyonight", "habamax", "default" },
    },
    
    checker = {
      enabled = not is_nixos,
      frequency = 86400,
      notify = false,
    },
    
    change_detection = {
      enabled = true,
      notify = false,
    },
    
    performance = {
      cache = { enabled = true },
      reset_packpath = true,
      rtp = {
        reset = true,
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
    
    ui = {
      border = "rounded",
      size = { width = 0.8, height = 0.8 },
      icons = {
        cmd = " ",
        config = " ",
        event = " ",
        ft = " ",
        init = " ",
        keys = " ",
        plugin = " ",
        runtime = " ",
        source = " ",
        start = " ",
        task = " ",
        lazy = "󰒲 ",
        loaded = "●",
        not_loaded = "○",
        list = { "●", "➜", "★", "‒" },
      },
    },
    
    debug = _G.nvim_config.environment.is_dev_mode,
  })
end)

if not setup_ok then
  _G.log.error("Lazy.nvim setup failed: " .. tostring(setup_err))
  vim.notify(
    "Lazy.nvim setup failed!\n\nError: " .. tostring(setup_err),
    vim.log.levels.ERROR,
    { title = "Plugin Manager Error", timeout = 10000 }
  )
  return false
end

_G.log.info("✓ Lazy.nvim setup completed")

-- Setup keymaps
local keymaps = {
  { "n", "<leader>L", "<cmd>Lazy<cr>", "Open Lazy" },
  { "n", "<leader>Li", "<cmd>Lazy install<cr>", "Install plugins" },
  { "n", "<leader>Lu", "<cmd>Lazy update<cr>", "Update plugins" },
  { "n", "<leader>Ls", "<cmd>Lazy sync<cr>", "Sync plugins" },
  { "n", "<leader>Lc", "<cmd>Lazy check<cr>", "Check for updates" },
  { "n", "<leader>Ll", "<cmd>Lazy log<cr>", "View log" },
  { "n", "<leader>Lp", "<cmd>Lazy profile<cr>", "Profile startup" },
  { "n", "<leader>Lx", "<cmd>Lazy clean<cr>", "Clean unused plugins" },
}

for _, map in ipairs(keymaps) do
  vim.keymap.set(map[1], map[2], map[3], { desc = "Lazy: " .. map[4] })
end

_G.log.info("✓ Lazy.nvim keymaps configured")

return true
```

### 3.3 Enhanced Health Check

**Add to `init.lua` in the HEALTH CHECK SYSTEM section:**

```lua
-- Register lazy.nvim health check
HealthCheck.register("Lazy.nvim availability", function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if vim.loop.fs_stat(lazypath) then
    local ok, _ = pcall(require, "lazy")
    return ok, ok and "Lazy.nvim loaded" or "Lazy.nvim found but failed to load"
  end
  return false, "Lazy.nvim not installed at: " .. lazypath
end)

-- Register plugin directory check
HealthCheck.register("Plugin directory", function()
  local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
  return vim.loop.fs_stat(plugin_dir) ~= nil, "Plugins directory: " .. plugin_dir
end)

-- Register system dependencies
HealthCheck.register("Ripgrep availability", function()
  return vim.fn.executable("rg") == 1 or vim.fn.executable("ripgrep") == 1
end)

HealthCheck.register("fd availability", function()
  return vim.fn.executable("fd") == 1
end)

HealthCheck.register("Git availability", function()
  return vim.fn.executable("git") == 1
end)
```

### 3.4 Test the Fixes

```bash
# Start Neovim with debug mode
NVIM_DEV_MODE=1 nvim

# Inside Neovim:
:messages                 # Check initialization logs
:NvimConfigStatus        # Check overall status
:Lazy                    # Should open successfully
:Lazy install            # Install any missing plugins
:checkhealth lazy        # Verify lazy health
```

---

## Phase 4: Create Standalone Flake

### 4.1 Flake Structure

```
~/.config/nvim/
├── flake.nix              # Main flake
├── flake.lock             # Lock file
├── init.lua               # Main config
├── lua/                   # Lua modules
├── nix/                   # Nix modules
│   ├── neovim.nix         # Neovim package
│   ├── plugins.nix        # Plugin definitions
│   └── dependencies.nix   # System dependencies
├── README.md
└── instructions.md        # This file
```

### 4.2 Create flake.nix

**Create `~/.config/nvim/flake.nix`:**

```nix
{
  description = "Production-Grade Neovim Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # System dependencies required for full functionality
        systemDependencies = with pkgs; [
          # Core tools
          ripgrep         # Live grep in Telescope
          fd              # Fast file finding
          git             # Version control
          
          # Build tools for native extensions
          gcc
          gnumake
          cmake
          
          # Optional but recommended
          nodejs          # For many LSP servers
          tree-sitter     # Syntax parsing
          sqlite          # Frecency database
        ];

        # Neovim with custom configuration
        neovimConfigured = pkgs.neovim.override {
          configure = {
            customRC = ''
              lua << EOF
              -- Set up paths
              vim.g.mapleader = " "
              vim.g.maplocalleader = "\\"
              
              -- Source main config
              dofile("${self}/init.lua")
              EOF
            '';
          };
        };

        # Create a wrapped neovim with all dependencies
        neovimWrapped = pkgs.writeShellScriptBin "nvim" ''
          export PATH="${pkgs.lib.makeBinPath systemDependencies}:$PATH"
          exec ${neovimConfigured}/bin/nvim "$@"
        '';

      in
      {
        # Default package
        packages.default = neovimWrapped;
        
        # Explicit package
        packages.neovim = neovimWrapped;

        # Development shell with all tools
        devShells.default = pkgs.mkShell {
          buildInputs = [ neovimWrapped ] ++ systemDependencies;
          
          shellHook = ''
            echo "🚀 Neovim Development Environment"
            echo "   Run 'nvim' to start"
            echo "   Config: ${self}"
            echo ""
            echo "Available tools:"
            echo "  - ripgrep (rg)"
            echo "  - fd"
            echo "  - git"
            echo "  - gcc, make, cmake"
          '';
        };

        # Formatter
        formatter = pkgs.nixpkgs-fmt;

        # Apps
        apps.default = {
          type = "app";
          program = "${neovimWrapped}/bin/nvim";
        };
      }
    );
}
```

### 4.3 Create Nix Modules

**Create `nix/dependencies.nix`:**

```nix
{ pkgs }:
{
  # Essential dependencies
  essential = with pkgs; [
    ripgrep
    fd
    git
  ];

  # Build tools
  build = with pkgs; [
    gcc
    gnumake
    cmake
  ];

  # Optional tools
  optional = with pkgs; [
    nodejs
    tree-sitter
    sqlite
    curl
    wget
  ];

  # Language servers (can be extended)
  lsp = with pkgs; [
    lua-language-server
    nil                    # Nix LSP
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    pyright
    rust-analyzer
  ];
}
```

### 4.4 Initialize Flake

```bash
cd ~/.config/nvim

# Initialize flake if not already done
git init
git add .

# Generate lock file
nix flake lock

# Check flake
nix flake check

# Show flake info
nix flake show
```

### 4.5 Test Standalone Flake

```bash
# Run from flake
nix run .#neovim

# Or use the default
nix run .

# Enter dev shell
nix develop

# In dev shell, nvim is available with all tools
nvim

# Build the package
nix build .#neovim

# Run the built package
./result/bin/nvim

# Install to profile
nix profile install .#neovim
```

### 4.6 Publish to GitHub

```bash
cd ~/.config/nvim

# Add remote if not already added
git remote add origin git@github.com:VoidNxSEC/nvim.git

# Commit everything
git add .
git commit -m "feat: create standalone neovim flake"

# Push
git push -u origin main

# Now others can use:
# nix run github:VoidNxSEC/nvim
```

---

## Phase 5: System Integration

### 5.1 Integrate into Main Flake

**Modify your main `nixos/flake.nix`:**

```nix
{
  description = "home sweet home";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Add neovim config as input
    nvim-config = {
      url = "git+file:///home/kernelcore/.config/nvim";
      # Or when published:
      # url = "github:VoidNxSEC/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # ... other inputs
  };

  outputs = { self, nixpkgs, home-manager, nvim-config, ... }@inputs: {
    nixosConfigurations = {
      kernelcore = nixpkgs.lib.nixosSystem {
        # ... existing config
        
        modules = [
          # ... existing modules
          
          home-manager.nixosModules.home-manager
          {
            home-manager.users.kernelcore = { pkgs, ... }: {
              # Use the neovim from the flake
              home.packages = [
                nvim-config.packages.${pkgs.system}.default
              ];
              
              # Remove embedded config from home.nix
              # The flake handles everything now
            };
          }
        ];
      };
    };
  };
}
```

### 5.2 Simplify home.nix

**Update `nixos/home.nix`:**

```nix
{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Remove the embedded init.lua section entirely
  # home.file.".config/nvim/init.lua".text = ''...'';  # DELETE
  
  # Neovim is now provided by the flake input
  # No need to manage it here
  
  home.packages = with pkgs; [
    # Remove neovim from here if it's listed
    # It comes from the flake now
    
    # Keep other packages...
  ];
  
  # ... rest of config
}
```

### 5.3 Rebuild System

```bash
# Update flake lock to include new input
cd /etc/nixos  # or wherever your main flake is
nix flake lock --update-input nvim-config

# Rebuild
sudo nixos-rebuild switch --flake .#kernelcore --show-trace

# Verify neovim works
nvim --version
nvim
```

### 5.4 Development Workflow

**For daily development:**

```bash
# Edit nvim config
cd ~/.config/nvim
nvim lua/plugins/telescope.lua

# Test changes immediately (no rebuild needed!)
nvim
:source %

# When ready to commit
git add .
git commit -m "feat: improve telescope config"
git push

# Update system flake to use new version
cd /etc/nixos  # or your flake location
nix flake lock --update-input nvim-config
sudo nixos-rebuild switch --flake .#kernelcore
```

---

## Validation & Testing

### 6.1 Functionality Checklist

Run through this checklist to verify everything works:

#### Core Functionality
- [ ] Neovim starts without errors
- [ ] `:checkhealth` shows no critical issues
- [ ] `:NvimConfigStatus` shows all modules loaded
- [ ] Leader key (`<Space>`) works
- [ ] Basic editing (insert, visual, etc.) works

#### Plugin Manager
- [ ] `:Lazy` opens plugin manager
- [ ] `:Lazy install` can install plugins
- [ ] `:Lazy update` can update plugins
- [ ] `:Lazy clean` can remove unused plugins
- [ ] Plugin loading is lazy (fast startup)

#### Telescope
- [ ] `<leader>ff` opens file finder
- [ ] `<leader>fg` opens live grep
- [ ] `<leader>fb` opens buffer list
- [ ] File preview works
- [ ] Fuzzy finding works correctly

#### LSP
- [ ] `gd` goes to definition
- [ ] `gr` shows references
- [ ] `K` shows hover documentation
- [ ] `<leader>ca` shows code actions
- [ ] `<leader>cf` formats code
- [ ] Diagnostics show up

#### Completion
- [ ] Autocomplete triggers in insert mode
- [ ] Tab/Shift-Tab cycles through completions
- [ ] Snippet expansion works
- [ ] Sources (LSP, buffer, path) work

#### Treesitter
- [ ] Syntax highlighting works
- [ ] Code folding works
- [ ] Indent guides work
- [ ] Text objects work

#### Git Integration
- [ ] Git signs show in gutter
- [ ] `]c` and `[c` navigate hunks
- [ ] `<leader>hs` stages hunks
- [ ] `<leader>hb` shows blame

#### File Explorer
- [ ] File explorer opens
- [ ] Can navigate directories
- [ ] Can create/delete files
- [ ] Can rename files

#### Terminal
- [ ] Terminal can open
- [ ] Can switch between editor and terminal
- [ ] Multiple terminals work

### 6.2 Performance Tests

```bash
# Measure startup time
nvim --startuptime startup.log +q
cat startup.log | tail -1

# Should be under 100ms for lazy loading
# Check in nvim:
:lua print(_G.nvim_config.metrics.total_startup_time .. "ms")

# Profile with lazy
nvim
:Lazy profile

# Look for slow plugins (anything > 5ms on startup)
```

### 6.3 System Integration Tests

```bash
# Test from different directories
cd ~
nvim

cd ~/projects
nvim

cd /tmp
nvim

# Test with files
nvim test.lua
nvim test.py
nvim test.nix

# Test with arguments
nvim +PluginStatus
nvim -c "Telescope find_files"
```

### 6.4 Flake Tests

```bash
# Test standalone flake
cd ~/.config/nvim
nix flake check
nix build .#neovim
./result/bin/nvim

# Test system integration
cd /etc/nixos  # or your flake location
nix flake check
nix flake show

# Test flake from URL
nix run github:VoidNxSEC/nvim  # if published
```

---

## Troubleshooting

### 7.1 lazy.nvim Not Loading

**Symptoms:**
- Warning: "Lazy.nvim not available"
- `:Lazy` command not found
- No plugins loaded

**Solutions:**

1. **Check if lazy exists:**
   ```bash
   ls -la ~/.local/share/nvim/lazy/lazy.nvim
   ```

2. **Install manually if missing:**
   ```bash
   git clone --filter=blob:none https://github.com/folke/lazy.nvim.git \
     --branch=stable \
     ~/.local/share/nvim/lazy/lazy.nvim
   ```

3. **Check permissions:**
   ```bash
   ls -la ~/.local/share/nvim/
   # Should be owned by your user, not root
   ```

4. **Re-initialize:**
   ```bash
   rm -rf ~/.local/share/nvim/lazy
   nvim  # Will auto-install on next start
   ```

### 7.2 Plugins Not Loading

**Symptoms:**
- `:Lazy` shows empty list
- Telescope/LSP not working
- "module not found" errors

**Solutions:**

1. **Check plugin directory:**
   ```bash
   ls -la ~/.config/nvim/lua/plugins/
   ```

2. **Verify imports:**
   ```vim
   :lua print(vim.inspect(require("lazy.core.config").spec.modules))
   ```

3. **Force reinstall:**
   ```vim
   :Lazy clean
   :Lazy install
   :Lazy sync
   ```

4. **Check for errors:**
   ```vim
   :Lazy log
   :messages
   ```

### 7.3 Read-Only File System

**Symptoms:**
- Can't save files in `~/.config/nvim/`
- "Permission denied" errors
- Files owned by root or in Nix store

**Solutions:**

1. **Check ownership:**
   ```bash
   ls -la ~/.config/nvim/
   sudo chown -R $USER:$USER ~/.config/nvim/
   ```

2. **Verify it's not a Nix store symlink:**
   ```bash
   realpath ~/.config/nvim/init.lua
   # Should NOT contain /nix/store/
   ```

3. **Re-apply Phase 2** (Decouple from Nix Store)

### 7.4 System Dependencies Missing

**Symptoms:**
- Telescope live grep doesn't work
- "rg not found" or "fd not found"
- Compilation errors for plugins

**Solutions:**

1. **Install via Nix:**
   ```nix
   # In configuration.nix or home.nix
   home.packages = with pkgs; [
     ripgrep
     fd
     gcc
     gnumake
     cmake
   ];
   ```

2. **Or use the flake** (includes all deps):
   ```bash
   nix develop ~/path/to/nvim-flake
   ```

3. **Check if available:**
   ```bash
   which rg fd gcc make
   ```

### 7.5 LSP Not Working

**Symptoms:**
- No completions
- No go-to-definition
- No diagnostics

**Solutions:**

1. **Check Mason:**
   ```vim
   :Mason
   :LspInfo
   ```

2. **Install language servers:**
   ```vim
   :Mason
   " Navigate and press 'i' to install servers
   ```

3. **Check if LSP is attached:**
   ```vim
   :lua print(vim.inspect(vim.lsp.get_active_clients()))
   ```

4. **Restart LSP:**
   ```vim
   :LspRestart
   ```

### 7.6 Telescope Not Finding Files

**Symptoms:**
- Empty results in file finder
- Live grep doesn't work
- Slow searching

**Solutions:**

1. **Check ripgrep:**
   ```bash
   which rg
   rg --version
   ```

2. **Check fd:**
   ```bash
   which fd
   fd --version
   ```

3. **Test manually:**
   ```bash
   cd ~/projects
   rg "function"
   fd ".lua$"
   ```

4. **Rebuild telescope-fzf-native:**
   ```vim
   :Lazy build telescope-fzf-native.nvim
   ```

### 7.7 Git Signs Not Showing

**Symptoms:**
- No git indicators in gutter
- Git commands not working
- Can't stage hunks

**Solutions:**

1. **Check if in git repo:**
   ```bash
   git status
   ```

2. **Verify gitsigns loaded:**
   ```vim
   :lua print(package.loaded["gitsigns"])
   ```

3. **Restart gitsigns:**
   ```vim
   :Gitsigns refresh
   ```

### 7.8 Slow Startup Time

**Symptoms:**
- Neovim takes > 100ms to start
- Feels sluggish
- `:Lazy profile` shows slow plugins

**Solutions:**

1. **Profile startup:**
   ```bash
   nvim --startuptime startup.log +q
   cat startup.log
   ```

2. **Check lazy loading:**
   ```vim
   :Lazy profile
   " Look for plugins loading on startup
   ```

3. **Disable problematic plugins:**
   ```lua
   -- In plugin config
   {
     "slow-plugin",
     enabled = false,  -- Temporarily disable
   }
   ```

4. **Clear cache:**
   ```bash
   rm -rf ~/.local/share/nvim/lazy/cache
   rm -rf ~/.cache/nvim
   ```

### 7.9 Flake Build Errors

**Symptoms:**
- `nix build` fails
- `nix flake check` shows errors
- Can't update flake

**Solutions:**

1. **Update flake lock:**
   ```bash
   nix flake update
   ```

2. **Check syntax:**
   ```bash
   nix flake check --show-trace
   ```

3. **Fix common issues:**
   ```nix
   # Ensure all inputs are defined
   # Check that outputs match inputs
   # Verify system is correct (x86_64-linux)
   ```

4. **Clean build cache:**
   ```bash
   nix-collect-garbage
   nix store gc
   ```

---

## Quick Reference

### Common Commands

```bash
# Diagnostics
nvim                          # Start Neovim
:NvimConfigStatus            # Check config status
:checkhealth                 # Run health checks
:Lazy                        # Open plugin manager
:Mason                       # Open LSP installer

# System
sudo nixos-rebuild switch --flake .#kernelcore    # Rebuild system
nix flake update                                  # Update flake
nix flake check                                   # Check flake
nix develop                                       # Enter dev shell

# Git
cd ~/.config/nvim
git status
git add .
git commit -m "message"
git push
```

### File Locations

```
~/.config/nvim/              # Main config directory
~/.local/share/nvim/lazy/    # Lazy.nvim plugins
~/.local/share/nvim/mason/   # Mason LSP servers
~/nixos/                     # System flake
/etc/nixos/                  # Alternative system flake location
```

### Important Keybindings

```
<Space>        Leader key
<leader>ff     Find files (Telescope)
<leader>fg     Live grep (Telescope)
<leader>fb     Buffers (Telescope)
<leader>L      Open Lazy
<leader>ca     Code actions
<leader>cf     Format code
gd             Go to definition
gr             Go to references
K              Hover documentation
```

---

## Next Steps

1. **Start with Phase 1** - Run diagnostics to understand current state
2. **Execute Phase 2** - Decouple from Nix store for development
3. **Apply Phase 3** - Fix lazy.nvim with enhanced logging
4. **Create Phase 4** - Build standalone flake for portability
5. **Complete Phase 5** - Integrate back into system flake

## Support

- **Documentation**: See `instructions/CLAUDE.md` for architecture details
- **Issues**: Check `:NvimConfigStatus` for error details
- **Logs**: Enable with `NVIM_DEV_MODE=1 nvim`
- **Community**: Consult Neovim and NixOS communities for help

---

**Last Updated**: 2025-01-07  
**Maintainer**: VoidNxSEC  
**License**: MIT
