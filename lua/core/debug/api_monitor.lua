-- lua/core/debug/api_monitor.lua
local M = {}

function M.get_stats()
  return {
    gemini = { total = 0, errors = 0, avg_latency = 0 },
    anthropic = { total = 0, errors = 0, avg_latency = 0 },
    openai = { total = 0, errors = 0, avg_latency = 0 },
  }
end

function M.get_certificates()
  return {}
end

return M
