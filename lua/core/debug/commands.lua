-- nvim/lua/core/debug/commands.lua
-- Comandos de usuário centralizados para o sistema de debug

local M = {}

-- Cache de módulos
local modules = {}
-- Dashboard server instance
local dashboard_server = nil

local function lazy_require(name)
  if not modules[name] then
    local ok, mod = pcall(require, name)
    if ok then
      modules[name] = mod
    else
      vim.notify("[Debug] Failed to load " .. name .. ": " .. tostring(mod), vim.log.levels.ERROR)
      return nil
    end
  end
  return modules[name]
end

--- Setup all user commands
function M.setup()
  local commands = {
    -- ═══════════════════════════════════════════════════════════════════
    -- DEBUG CORE
    -- ═══════════════════════════════════════════════════════════════════
    {
      name = "DebugEnable",
      callback = function()
        local debug = lazy_require("core.debug")
        if debug and debug.config then
          debug.config.enabled = true
          vim.notify("[Debug] Sistema de debug ativado", vim.log.levels.INFO)
        end
      end,
      desc = "Ativa o sistema de debug"
    },
    {
      name = "DebugDisable",
      callback = function()
        local debug = lazy_require("core.debug")
        if debug and debug.config then
          debug.config.enabled = false
          vim.notify("[Debug] Sistema de debug desativado", vim.log.levels.INFO)
        end
      end,
      desc = "Desativa o sistema de debug"
    },
    {
      name = "DebugStatus",
      callback = function()
        local debug = lazy_require("core.debug")
        local config = lazy_require("core.debug.config")
        if config then
          local status = config.enabled and "ATIVADO" or "DESATIVADO"
          local log_file = config.log_file or "N/A"
          vim.notify(string.format(
            "[Debug] Status: %s\nLog file: %s\nLevel: %s",
            status, log_file, tostring(config.log_level)
          ), vim.log.levels.INFO)
        end
      end,
      desc = "Mostra status do sistema de debug"
    },

    -- ═══════════════════════════════════════════════════════════════════
    -- INSPECTOR
    -- ═══════════════════════════════════════════════════════════════════
    {
      name = "DebugInspect",
      callback = function()
        local inspector = lazy_require("core.debug.inspector")
        if inspector then
          inspector.quick_inspect()
        end
      end,
      desc = "Inspeciona estado atual do Neovim"
    },
    {
      name = "DebugDashboard",
      callback = function(opts)
        local inspector = lazy_require("core.debug.inspector")
        if inspector then
          local port = tonumber(opts.args) or 8080
          local server = inspector.start_dashboard(port)
          if server then
            dashboard_server = server
          end
        end
      end,
      opts = { nargs = "?" },
      desc = "Inicia dashboard HTTP (porta opcional, default 8080)"
    },
    {
      name = "DebugDashboardStop",
      callback = function()
        local inspector = lazy_require("core.debug.inspector")
        if inspector and dashboard_server then
          inspector.stop_dashboard(dashboard_server)
          dashboard_server = nil
        end
      end,
      desc = "Para o dashboard HTTP"
    },

    -- ═══════════════════════════════════════════════════════════════════
    -- PROFILER
    -- ═══════════════════════════════════════════════════════════════════
    {
      name = "ProfileStart",
      callback = function(opts)
        local profiler = lazy_require("core.debug.profiler")
        if profiler then
          local name = opts.args ~= "" and opts.args or "default"
          profiler.start(name)
          vim.notify("[Profiler] Iniciado: " .. name, vim.log.levels.INFO)
        end
      end,
      opts = { nargs = "?" },
      desc = "Inicia profiling de uma seção"
    },
    {
      name = "ProfileStop",
      callback = function(opts)
        local profiler = lazy_require("core.debug.profiler")
        if profiler then
          local name = opts.args ~= "" and opts.args or "default"
          local elapsed = profiler.stop(name)
          vim.notify(string.format("[Profiler] %s: %.2fms", name, elapsed), vim.log.levels.INFO)
        end
      end,
      opts = { nargs = "?" },
      desc = "Para profiling e mostra tempo"
    },
    {
      name = "ProfileReport",
      callback = function()
        local profiler = lazy_require("core.debug.profiler")
        if profiler then
          local report = profiler.report()
          local lines = { "[Profiler] Report:" }
          for name, elapsed in pairs(report) do
            table.insert(lines, string.format("  %s: %.2fms", name, elapsed))
          end
          vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
        end
      end,
      desc = "Mostra relatório de profiling"
    },
    {
      name = "ProfileClear",
      callback = function()
        local profiler = lazy_require("core.debug.profiler")
        if profiler then
          profiler.clear()
          vim.notify("[Profiler] Dados limpos", vim.log.levels.INFO)
        end
      end,
      desc = "Limpa dados de profiling"
    },

    -- ═══════════════════════════════════════════════════════════════════
    -- STRESS TEST
    -- ═══════════════════════════════════════════════════════════════════
    {
      name = "StressTestStart",
      callback = function()
        local stress = lazy_require("core.debug.stress_test")
        if stress then stress.start() end
      end,
      desc = "Inicia stress test do Neovim"
    },
    {
      name = "StressTestStop",
      callback = function()
        local stress = lazy_require("core.debug.stress_test")
        if stress then
          local report = stress.stop()
          if report then
            vim.notify(string.format(
              "[StressTest] Completado em %ds\nMemory checks: %d",
              report.duration, #report.memory_checks
            ), vim.log.levels.INFO)
          end
        end
      end,
      desc = "Para stress test e mostra relatório"
    },
    {
      name = "StressTestStatus",
      callback = function()
        local stress = lazy_require("core.debug.stress_test")
        if stress then
          local status = stress.status()
          vim.notify(string.format(
            "[StressTest] Running: %s | Duration: %ds | Memory checks: %d",
            tostring(status.running), status.duration, status.memory_checks
          ), vim.log.levels.INFO)
        end
      end,
      desc = "Mostra status do stress test"
    },

    -- ═══════════════════════════════════════════════════════════════════
    -- FORENSIC
    -- ═══════════════════════════════════════════════════════════════════
    {
      name = "ForensicEnable",
      callback = function()
        local forensic = lazy_require("utils.forensic")
        if forensic then forensic.enable() end
      end,
      desc = "Ativa diagnóstico forense (intercepta require)"
    },
    {
      name = "ForensicDisable",
      callback = function()
        local forensic = lazy_require("utils.forensic")
        if forensic then forensic.disable() end
      end,
      desc = "Desativa diagnóstico forense"
    },
    {
      name = "ForensicTrace",
      callback = function(opts)
        local forensic = lazy_require("utils.forensic")
        if forensic then forensic.trace(opts.args) end
      end,
      opts = { nargs = "*" },
      desc = "Exibe stacktrace de um erro"
    },

    -- ═══════════════════════════════════════════════════════════════════
    -- LOGGER
    -- ═══════════════════════════════════════════════════════════════════
    {
      name = "LogFlush",
      callback = function()
        local logger = lazy_require("core.debug.logger")
        if logger then
          logger.flush()
          vim.notify("[Logger] Buffer gravado em disco", vim.log.levels.INFO)
        end
      end,
      desc = "Grava buffer de logs em disco"
    },
    {
      name = "LogView",
      callback = function()
        local config = lazy_require("core.debug.config")
        if config and config.log_file then
          vim.cmd("edit " .. config.log_file)
        end
      end,
      desc = "Abre arquivo de log no buffer"
    },
  }

  -- Registra todos os comandos
  for _, cmd in ipairs(commands) do
    local opts = vim.tbl_extend("force", {
      desc = cmd.desc,
    }, cmd.opts or {})
    vim.api.nvim_create_user_command(cmd.name, cmd.callback, opts)
  end

  vim.notify("[Debug] " .. #commands .. " comandos registrados", vim.log.levels.DEBUG)
end

return M
