-- nvim-cmp source: Pandoc citekeys (`[@key]`) from a CSL-JSON file, e.g. a Better BibTeX auto-export.
--
-- File: `vim.b.citekeys_json` or `vim.g.citekeys_json`, else <astro repo>/src/data/references.json,
-- where the repo is the nearest ancestor of the buffer's realpath containing astro.config.mjs
-- (resolved via the nearest existing directory, so unsaved buffers work too).
-- Re-read whenever the file's mtime changes.

local M = {}

---@type table<string, { mtime: string, items: table[] }>
local cache = {}

-- Repo export for a buffer, cached in vim.b (false = none); cleared when the buffer is renamed.
local function repo_path(buf)
  local cached = vim.b[buf].citekeys_repo_json
  if cached ~= nil then
    return cached or nil
  end
  local real = require('custom.herden').resolve(vim.api.nvim_buf_get_name(buf))
  local root = real and vim.fs.root(real, 'astro.config.mjs')
  local path = root and vim.fs.joinpath(root, 'src', 'data', 'references.json')
  vim.b[buf].citekeys_repo_json = path or false
  return path
end

vim.api.nvim_create_autocmd('BufFilePost', {
  group = vim.api.nvim_create_augroup('CitekeysPath', { clear = true }),
  callback = function(ev)
    vim.b[ev.buf].citekeys_repo_json = nil
  end,
})

local function json_path(buf)
  local override = vim.b[buf].citekeys_json or vim.g.citekeys_json
  local path = override and vim.fn.expand(override) or repo_path(buf)
  return path and vim.fn.filereadable(path) == 1 and path or nil
end

local function str(v)
  return type(v) == 'string' and v or nil
end

local function authors(ref)
  local list = type(ref.author) == 'table' and ref.author or type(ref.editor) == 'table' and ref.editor or {}
  local names = {}
  for _, a in ipairs(list) do
    local name = type(a) == 'table' and (str(a.family) or str(a.literal))
    if name then
      table.insert(names, name)
    end
  end
  return table.concat(names, ', ')
end

local function year(ref)
  local parts = type(ref.issued) == 'table' and ref.issued['date-parts']
  local first = type(parts) == 'table' and parts[1]
  local y = type(first) == 'table' and first[1]
  return (type(y) == 'number' or type(y) == 'string') and tostring(y) or ''
end

local function to_items(refs)
  local kind = require('cmp').lsp.CompletionItemKind.Reference
  local items = {}
  for _, ref in ipairs(refs) do
    local id = type(ref) == 'table' and str(ref.id)
    if id then
      local by = authors(ref)
      table.insert(items, {
        label = '@' .. id,
        filterText = '@' .. id .. ' ' .. by,
        kind = kind,
        documentation = {
          kind = 'markdown',
          value = string.format('**%s**\n\n%s %s', str(ref.title) or '', by, year(ref)),
        },
      })
    end
  end
  return items
end

local function load(path)
  local stat = vim.uv.fs_stat(path)
  if not stat then
    return {}
  end
  local mtime = stat.mtime.sec .. '.' .. stat.mtime.nsec
  local entry = cache[path] or { items = {} }
  if entry.mtime == mtime then
    return entry.items
  end
  -- Record the mtime first: a broken export is parsed (and warned about) once, not on every keystroke.
  entry.mtime = mtime
  cache[path] = entry

  local ok, refs = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), '\n'), { luanil = { object = true, array = true } })
  if not ok or type(refs) ~= 'table' then
    vim.notify('citekeys: cannot parse ' .. path .. '; keeping previous entries', vim.log.levels.WARN)
    return entry.items
  end
  entry.items = to_items(refs)
  return entry.items
end

local source = {}

function source:is_available()
  return json_path(vim.api.nvim_get_current_buf()) ~= nil
end

function source:get_trigger_characters()
  return { '@' }
end

function source:get_keyword_pattern()
  return [[@[^[:blank:]\];,]*]]
end

function source:complete(params, callback)
  -- Only inside a bracketed citation: `[@`, `[see @`, `[@a; @`.
  if not params.context.cursor_before_line:match '%[[^%]]*@[^%s%];,]*$' then
    return callback {}
  end
  local path = json_path(params.context.bufnr)
  callback(path and load(path) or {})
end

function M.new()
  return setmetatable({}, { __index = source })
end

return M
