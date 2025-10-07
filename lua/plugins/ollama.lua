-- ollama.lua
local api = require('plenary.api')
local uv = require('uv')

local function send_to_ollama(prompt)
    local url = "http://localhost:11434/api/generate"
    local payload = {
        model = "llama3",
        prompt = prompt,
        stream = true
    }

    local req, err = uv.http.request(url, "POST", payload)
    if not req then
        print("Error connecting to Ollama: " .. err)
        return
    end

    local response = ""
    req:once("data", function(chunk)
        response = response .. chunk
        -- Process streamed response (e.g., append to a buffer)
    end)

    req:once("end", function()
        print("Ollander response: " .. response)
    end)
end

-- Example: Use in a command
vim.api.nvim_command("command! -nargs=* Ollama lua send_to_ollama(<args>)")
