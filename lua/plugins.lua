-- Aggregates lazy.nvim specs from lua/plugins/*.lua (non-recursive, so the
-- per-plugin setup modules in lua/plugins/config/ are not picked up as specs).
--
-- Load errors are reported rather than swallowed: a syntax error in one spec
-- file used to silently disable every plugin it declared, which is very hard to
-- diagnose from the outside.
local specs = {}

local dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "plugins")
local names = {}
for name, kind in vim.fs.dir(dir) do
  if kind == "file" and name:match("%.lua$") then
    table.insert(names, name)
  end
end
table.sort(names) -- deterministic load order

for _, name in ipairs(names) do
  local mod = "plugins." .. name:gsub("%.lua$", "")
  local ok, result = pcall(require, mod)
  if not ok then
    vim.notify(("plugins: %s failed to load\n%s"):format(mod, result), vim.log.levels.ERROR)
  elseif type(result) ~= "table" then
    vim.notify(("plugins: %s must return a table, got %s"):format(mod, type(result)), vim.log.levels.ERROR)
  else
    vim.list_extend(specs, result)
  end
end

return specs
