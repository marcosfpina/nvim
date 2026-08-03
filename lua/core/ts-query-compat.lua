-- Compat shim for nvim-treesitter's `master` branch on Neovim 0.12+.
--
-- Upstream confirmed `master` is obsolete for Nvim 0.12
-- (https://github.com/nvim-treesitter/nvim-treesitter/issues/8618):
-- core's query.add_directive/add_predicate handlers now always receive
-- `match[capture_id]` as a `TSNode[]` list, but nvim-treesitter's
-- query_predicates.lua (nth?, is?, kind-eq?, set-lang-from-mimetype!,
-- set-lang-from-info-string!, downcase!) still treats it as a single
-- TSNode. That mismatch crashes get_node_text()/get_range() with
-- "attempt to call method 'range' (a nil value)" on any markdown fenced
-- code block, HTML <script type=...> injection, etc.
--
-- This re-registers those handlers with the list unwrapped to a single
-- node, restoring the intended behavior without switching branches.
-- Delete this file (and its require in plugins/treesitter.lua) once the
-- repo migrates nvim-treesitter to the `main` branch.

local M = {}

function M.setup()
  require("nvim-treesitter.query_predicates")

  local query = vim.treesitter.query

  local function single_node(match, id)
    local node = match[id]
    if type(node) == "table" and node.range == nil then
      node = node[1]
    end
    return node
  end

  query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
    local node = single_node(match, pred[2])
    local n = tonumber(pred[3])
    if node and node:parent() and node:parent():named_child_count() > n then
      return node:parent():named_child(n) == node
    end
    return false
  end, { force = true })

  query.add_predicate("is?", function(match, _pattern, bufnr, pred)
    local locals = require("nvim-treesitter.locals")
    local node = single_node(match, pred[2])
    local types = { unpack(pred, 3) }

    if not node then
      return true
    end

    local _, _, kind = locals.find_definition(node, bufnr)
    return vim.tbl_contains(types, kind)
  end, { force = true })

  query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
    local node = single_node(match, pred[2])
    local types = { unpack(pred, 3) }

    if not node then
      return true
    end

    return vim.tbl_contains(types, node:type())
  end, { force = true })

  local html_script_type_languages = {
    ["importmap"] = "json",
    ["module"] = "javascript",
    ["application/ecmascript"] = "javascript",
    ["text/ecmascript"] = "javascript",
  }

  query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local node = single_node(match, pred[2])
    if not node then
      return
    end
    local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
    local configured = html_script_type_languages[type_attr_value]
    if configured then
      metadata["injection.language"] = configured
    else
      local parts = vim.split(type_attr_value, "/", {})
      metadata["injection.language"] = parts[#parts]
    end
  end, { force = true })

  local non_filetype_match_injection_language_aliases = {
    ex = "elixir",
    pl = "perl",
    sh = "bash",
    uxn = "uxntal",
    ts = "typescript",
  }

  local function get_parser_from_markdown_info_string(injection_alias)
    local match = vim.filetype.match({ filename = "a." .. injection_alias })
    return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
  end

  query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = single_node(match, pred[2])
    if not node then
      return
    end
    local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
    metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
  end, { force = true })

  query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
    local id = pred[2]
    local node = single_node(match, id)
    if not node then
      return
    end

    local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
    if not metadata[id] then
      metadata[id] = {}
    end
    metadata[id].text = string.lower(text)
  end, { force = true })
end

return M
