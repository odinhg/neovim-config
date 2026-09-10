-- nvim-cmp. Loaded from the nvim-cmp spec's `config`, so cmp is guaranteed
-- to exist by the time this runs.
local cmp = require("cmp")

-- Accept a Copilot ghost-text suggestion if one is showing, otherwise fall
-- through to whatever <Tab> would normally do.
local function copilot_or(fallback_fn)
  return function(fallback)
    local ok, suggestion = pcall(require, "copilot.suggestion")
    if ok and suggestion.is_visible() then
      fallback_fn(suggestion)
    else
      fallback()
    end
  end
end

cmp.setup({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
  }, {
    -- Second group: only consulted when the LSP returns nothing, which keeps
    -- harper-ls's word list from burying real completions in prose buffers.
    { name = "buffer" },
  }),
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-l>"] = cmp.mapping.confirm({ select = true }),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(copilot_or(function(s) s.accept() end), { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(copilot_or(function(s) s.accept_word() end), { "i", "s" }),
  }),
})
