-- Server registration, using the built-in `vim.lsp.config` API (Neovim 0.11+).
-- Definitions ship with nvim-lspconfig under its `lsp/` directory; the tables
-- below are merged on top of those defaults.

-- Advertise nvim-cmp's extra completion capabilities to every server.
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  vim.lsp.config("*", { capabilities = cmp_lsp.default_capabilities() })
end

-- Typst
--
-- TEMPORARILY DISABLED: tinymist's resident memory grows without bound on
-- larger projects and takes Neovim down with it. The config below is kept
-- intact; it is simply not in the `vim.lsp.enable` list further down. Run
-- `:TinymistStart` to bring it up by hand for the current session when the
-- editing features are worth the memory, or delete this note and re-add
-- "tinymist" to the enable list once upstream fixes the leak.
vim.lsp.config("tinymist", {
  settings = {
    formatterMode = "typstyle",
    exportPdf = "onSave",
    -- Left to Treesitter, which is faster and does not flicker on large files.
    semanticTokens = "disable",
  },
})

vim.api.nvim_create_user_command("TinymistStart", function()
  vim.lsp.enable("tinymist")
  -- `vim.lsp.enable` only attaches on the next FileType event, so re-trigger
  -- it for buffers that are already open.
  vim.cmd("silent! doautoall FileType")
end, { desc = "Start tinymist for this session (disabled by default: memory use)" })

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

-- "tinymist" is deliberately absent here -- see the note above.
vim.lsp.enable({ "harper_ls", "pyright", "ruff" })
