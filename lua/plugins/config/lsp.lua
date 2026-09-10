-- Server registration, using the built-in `vim.lsp.config` API (Neovim 0.11+).
-- Definitions ship with nvim-lspconfig under its `lsp/` directory; the tables
-- below are merged on top of those defaults.

-- Advertise nvim-cmp's extra completion capabilities to every server.
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  vim.lsp.config("*", { capabilities = cmp_lsp.default_capabilities() })
end

-- Typst
vim.lsp.config("tinymist", {
  settings = {
    formatterMode = "typstyle",
    exportPdf = "onSave",
    -- Left to Treesitter, which is faster and does not flicker on large files.
    semanticTokens = "disable",
  },
})

-- Grammar / spelling (see config/harper.lua)
vim.lsp.config("harper_ls", require("plugins.config.harper"))

-- Python: pyright for types, ruff for lint/format. Silence pyright's own
-- linting so the two don't report the same problem twice.
vim.lsp.config("pyright", {
  settings = {
    pyright = { disableOrganizeImports = true },
    python = { analysis = { typeCheckingMode = "basic" } },
  },
})

vim.lsp.enable({ "tinymist", "harper_ls", "pyright", "ruff" })
