-- herden.dev content roots: the vault folder on the Mac (a symlink into the repo), the repo checkout elsewhere.
local M = {}

M.candidates = { '~/Documents/Vault/herden.dev', '~/repos/herden-website/src/content' }

-- First candidate that exists on this host, or nil.
function M.path()
  for _, p in ipairs(M.candidates) do
    if vim.fn.isdirectory(vim.fn.expand(p)) == 1 then
      return p
    end
  end
end

-- Realpaths of the existing candidates.
function M.roots()
  local roots = {}
  for _, p in ipairs(M.candidates) do
    local real = vim.uv.fs_realpath(vim.fn.expand(p))
    if real and not vim.tbl_contains(roots, real) then
      table.insert(roots, real)
    end
  end
  return roots
end

-- Realpath of a file that may not exist yet: resolve the nearest existing ancestor, re-append the rest.
function M.resolve(file)
  if file == '' then
    return nil
  end
  local path = vim.fs.normalize(vim.fn.fnamemodify(file, ':p'))
  local rest = {}
  while true do
    local real = vim.uv.fs_realpath(path)
    if real then
      return #rest == 0 and real or vim.fs.joinpath(real, unpack(rest))
    end
    local parent = vim.fs.dirname(path)
    if parent == path then
      return nil
    end
    table.insert(rest, 1, vim.fs.basename(path))
    path = parent
  end
end

function M.contains(file)
  local real = M.resolve(file)
  if not real then
    return false
  end
  for _, root in ipairs(M.roots()) do
    if vim.fs.relpath(root, real) then
      return true
    end
  end
  return false
end

return M
