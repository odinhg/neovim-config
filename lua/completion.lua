-- nvim-cmp configuration
local present, cmp = pcall(require, "cmp")
if not present then
  return
end

cmp.setup({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
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
    ["<Tab>"] = cmp.mapping(function(fallback)
      if pcall(require, "copilot.suggestion") and require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if pcall(require, "copilot.suggestion") and require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept_word()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
})
