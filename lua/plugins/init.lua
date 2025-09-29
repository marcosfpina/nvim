-- /lua/plugins/init.lua
-- Central plugin loader to prevent "module 'plugins' not found" error

-- Load existing plugin configurations
local plugins = {}

-- Function to safely require a plugin module
local function safe_require(module_name)
  local ok, result = pcall(require, module_name)
  if ok then
    if type(result) == "table" then
      -- If it's a table, merge it into plugins
      for _, plugin in ipairs(result) do
        table.insert(plugins, plugin)
      end
    end
    return result
  else
    -- Silently skip missing modules in NixOS environment
    -- Only show debug message if not in headless mode
    if not vim.g.headless then
      vim.notify("Plugin module '" .. module_name .. "' not found, skipping...", vim.log.levels.DEBUG)
    end
    return {}
  end
end

-- Load existing plugin files
safe_require("plugins.ui")
safe_require("plugins.lsp")

-- Future plugin modules (will be loaded when they exist)
-- safe_require("plugins.editing")
-- safe_require("plugins.git")
-- safe_require("plugins.nav")
-- safe_require("plugins.coding")
-- safe_require("plugins.debug")
-- safe_require("plugins.lang")
-- safe_require("plugins.tools")
-- safe_require("plugins.ai")

return plugins