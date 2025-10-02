# Quick Start Guide: Production-Grade Neovim Configuration

## 🚀 Getting Started in 5 Minutes

This guide helps you quickly understand and use your new production-grade Neovim configuration.

## ✨ What's New?

Your Neovim configuration has been upgraded with:

- **Intelligent Error Handling**: Never crashes, always recovers gracefully
- **Performance Monitoring**: See exactly how fast your config loads
- **Health Checks**: Automatic system validation
- **Development Mode**: Enhanced debugging when you need it
- **Status Dashboard**: Real-time configuration diagnostics

## 📋 Basic Usage

### 1. Starting Neovim

Simply start Neovim as usual:

```bash
nvim
```

You'll see informational messages about the initialization process in INFO level (brief, non-intrusive).

### 2. Check Configuration Status

At any time, check your configuration health:

```vim
:NvimConfigStatus
```

This opens a floating window showing:
- Configuration version
- Environment details
- Load status
- Performance metrics
- Any errors or warnings

**Tip:** Press `q` or `<Esc>` to close the status window.

### 3. Enable Development Mode

For detailed debugging information:

```bash
# In your shell
export NVIM_DEV_MODE=1
nvim
```

This enables:
- DEBUG level logging
- Detailed module load times
- Verbose diagnostics
- Additional system information

**Note:** Only use development mode when troubleshooting.

## 🎮 Essential Commands

| Command | Description |
|---------|-------------|
| `:NvimConfigStatus` | Show configuration status and metrics |
| `:Lazy` | Open plugin manager |
| `:checkhealth` | Run Neovim health checks |
| `:messages` | View all log messages |

## 🔧 Configuration Files

Your configuration follows this structure:

```
~/.config/nvim/
├── init.lua                    # Production-grade entry point
├── lua/
│   ├── core/
│   │   ├── options.lua         # Neovim settings
│   │   ├── keymaps.lua         # Key mappings
│   │   ├── autocmds.lua        # Autocommands
│   │   ├── lazy.lua            # Plugin manager
│   │   └── utils.lua           # Helper functions
│   └── plugins/
│       ├── init.lua            # Plugin specifications
│       └── *.lua               # Individual plugin configs
└── PRODUCTION_ARCHITECTURE.md  # Detailed documentation
```

## 🎯 Key Features

### 1. Automatic Error Recovery

If a module fails to load, the configuration:
- Logs the error
- Continues with remaining modules
- Provides fallback implementations
- Shows clear error messages in `:NvimConfigStatus`

**Example:** If a plugin fails, you'll still have a working editor.

### 2. Performance Profiling

Every module tracks its load time:

```bash
# Start with detailed profiling
nvim --startuptime startup.log

# Or check interactively
:NvimConfigStatus
```

### 3. Environment Awareness

The configuration automatically detects:
- **NixOS**: Adjusts for system-managed packages
- **WSL**: Windows Subsystem for Linux
- **SSH**: Remote sessions
- **Dev Mode**: Enhanced debugging

### 4. Logging System

Access logs at different levels:

```lua
-- In Neovim command line
:lua _G.log.info("This is an info message")
:lua _G.log.warn("This is a warning")
:lua _G.log.error("This is an error")
```

View all messages: `:messages`

## 🐛 Troubleshooting

### Problem: Configuration loads slowly

**Solution:**
```bash
# 1. Enable dev mode
export NVIM_DEV_MODE=1
nvim

# 2. Check status
:NvimConfigStatus

# 3. Profile startup
nvim --startuptime startup.log
cat startup.log
```

Look for modules taking > 50ms.

### Problem: Module fails to load

**Solution:**
```vim
:NvimConfigStatus
```

Check the "Recent Errors" section for details. The error will include:
- Timestamp
- Module name
- Error message

### Problem: Plugins not working

**Solution:**
```vim
:Lazy check
:Lazy health
```

Ensure plugins are installed and healthy.

### Problem: Want to see detailed logs

**Solution:**
```bash
# Enable development mode
export NVIM_DEV_MODE=1
nvim

# Or temporarily in Neovim
:lua _G.log.debug("Debug info", {some = "data"})
:messages
```

## 🎨 Customization

### Adding a New Module

1. Create your module file: `lua/custom/mymodule.lua`

2. Add to `init.lua` in the appropriate section:

```lua
-- Add to core_modules array for critical modules
{
  module = "custom.mymodule",
  opts = {
    required = false,              -- true if critical
    description = "My Custom Module",
    retry = false,
  }
}
```

3. Restart Neovim and check: `:NvimConfigStatus`

### Adjusting Log Level

By default:
- **Production**: INFO level
- **Development**: DEBUG level

To change permanently, edit `init.lua`:

```lua
-- Find this line:
local log_level = _G.nvim_config.environment.is_dev_mode and log_levels.DEBUG or log_levels.INFO

-- Change to:
local log_level = log_levels.WARN  -- Only warnings and errors
```

### Adding Health Checks

Add custom health checks in `init.lua`:

```lua
-- After existing health checks
HealthCheck.register("My custom check", function()
  -- Return true if check passes, false otherwise
  return vim.fn.executable("my_tool") == 1
end)
```

## 📊 Performance Benchmarks

Expected startup times:

| Component | Target | Good | Needs Attention |
|-----------|--------|------|-----------------|
| Core modules | < 50ms | < 100ms | > 100ms |
| Plugin manager | < 100ms | < 200ms | > 200ms |
| Total (no plugins) | < 200ms | < 400ms | > 400ms |

**Check your metrics:**
```vim
:NvimConfigStatus
```

## 🌟 Pro Tips

### 1. Quick Status Check

Add this to your shell profile for easy status checks:

```bash
alias nvim-status='nvim -c "NvimConfigStatus" -c "only"'
```

### 2. Profiling Shortcuts

Create a shell function:

```bash
nvim-profile() {
  nvim --startuptime /tmp/startup.log "$@"
  tail -20 /tmp/startup.log
}
```

### 3. Debug Mode Alias

```bash
alias nvim-debug='NVIM_DEV_MODE=1 nvim'
```

### 4. Module Load Times

Check specific module performance:

```vim
:lua print(vim.inspect(_G.nvim_config.metrics.module_load_times))
```

## 📚 Learn More

- **Architecture Details**: Read `PRODUCTION_ARCHITECTURE.md`
- **Neovim Help**: `:help` in Neovim
- **Plugin Manager**: `:help lazy.nvim`
- **Lua Guide**: `:help lua-guide`

## 🔄 Regular Maintenance

### Weekly
```vim
:NvimConfigStatus  " Check for errors
```

### Monthly
```vim
:Lazy update      " Update plugins (if not on NixOS)
:checkhealth      " Validate configuration
```

### When Issues Occur
```bash
# 1. Enable debug mode
export NVIM_DEV_MODE=1

# 2. Start Neovim
nvim

# 3. Check status
:NvimConfigStatus

# 4. View logs
:messages
```

## 🆘 Getting Help

### Check Configuration
```vim
:NvimConfigStatus
```

### Check Neovim Health
```vim
:checkhealth
```

### View All Messages
```vim
:messages
```

### Get Plugin Help
```vim
:Lazy
:help lazy.nvim
```

### Debug Specific Module
```vim
:lua require('your.module')  " Will show any errors
```

## 🎓 Common Workflows

### Starting a New Project

1. Open Neovim in project directory
2. Let plugins load automatically
3. Check status if needed: `:NvimConfigStatus`
4. Start coding!

### Debugging Configuration Issues

1. Enable dev mode: `export NVIM_DEV_MODE=1`
2. Start Neovim
3. Check status: `:NvimConfigStatus`
4. Review errors in status window
5. Check detailed logs: `:messages`

### Adding a New Plugin

1. Add plugin spec to `lua/plugins/*.lua`
2. Restart Neovim (or `:Lazy reload`)
3. Install: `:Lazy install`
4. Verify: `:Lazy health`

### Performance Optimization

1. Profile startup: `nvim --startuptime startup.log`
2. Check metrics: `:NvimConfigStatus`
3. Identify slow modules (> 50ms)
4. Consider lazy loading or optimization

## ✅ Verification Checklist

After setting up, verify everything works:

- [ ] `:NvimConfigStatus` shows no errors
- [ ] Startup time < 400ms (without plugins)
- [ ] All core modules loaded successfully
- [ ] Plugin manager accessible (`:Lazy`)
- [ ] Health checks pass (`:checkhealth`)
- [ ] No error messages in `:messages`

## 🎉 You're Ready!

Your Neovim configuration is now production-grade and ready for serious development work. Enjoy the enhanced reliability, performance, and observability!

---

**Need More Details?** Read `PRODUCTION_ARCHITECTURE.md` for comprehensive documentation.

**Questions or Issues?** Check `:NvimConfigStatus` first, then review the troubleshooting section above.
