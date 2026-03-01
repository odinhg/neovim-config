-- Aggregate all plugin specs from lua/plugins/*.lua
local plugins = {}
local plugin_files = {
  "plugins.core",
  "plugins.telescope",
  "plugins.treesitter",
  "plugins.lualine",
  "plugins.indent",
  "plugins.ui",
  "plugins.utils",
  "plugins.lsp",
  "plugins.misc",
}
for _, mod in ipairs(plugin_files) do
  local ok, tbl = pcall(require, mod)
  if ok and type(tbl) == "table" then
    for _, v in ipairs(tbl) do table.insert(plugins, v) end
  end
end
return plugins
