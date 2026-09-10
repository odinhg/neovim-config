-- Autocmds, diagnostics and filetype behaviour.

local augroup = function(name)
  return vim.api.nvim_create_augroup("User" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("YankHighlight"),
  callback = function()
    vim.hl.on_yank({ timeout = 500 })
  end,
})

-- Return to the last cursor position when reopening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("LastPosition"),
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

--- Diagnostics -------------------------------------------------------------
-- harper-ls reports at "information"; tinymist reports real errors. Showing
-- virtual text only for WARN and above keeps grammar notes from pushing the
-- line around while writing -- they still appear in the sign column and on
-- hover.
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
  float = { border = "rounded", source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})

--- LSP ---------------------------------------------------------------------
-- Neovim 0.11+ binds gra/gri/grn/grr/grt/grx globally. `gr` is mapped to
-- references on LSP attach, so leaving these in place makes every `gr` press
-- wait out 'timeoutlen' to see if a longer sequence follows. They are global
-- mappings, so they must be deleted globally and only once.
for _, lhs in ipairs({ "gra", "gri", "grn", "grr", "grt", "grx" }) do
  pcall(vim.keymap.del, "n", lhs)
end
pcall(vim.keymap.del, "v", "gra")

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("LspConfig"),
  callback = function(ev)
    local opts = function(desc)
      return { buffer = ev.buf, desc = desc }
    end

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("LSP: definition"))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("LSP: references"))
    vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts("LSP: rename"))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("LSP: hover"))
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("LSP: code action"))
    -- Replacements for the `gr*` defaults removed above.
    vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, opts("LSP: implementation"))
    vim.keymap.set("n", "<leader>cy", vim.lsp.buf.type_definition, opts("LSP: type definition"))
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts("Diagnostics: show at cursor"))
  end,
})

--- Prose -------------------------------------------------------------------
-- Soft-wrap at word boundaries for writing filetypes. `j`/`k` are already
-- mapped to `gj`/`gk`, so wrapped lines still navigate one screen line at a
-- time. Native 'spell' stays off: harper-ls does the spell checking and
-- understands Typst syntax, so it doesn't flag math or `#import` arguments.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("Prose"),
  pattern = { "typst", "markdown", "tex", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.spell = false
    vim.opt_local.conceallevel = 2
  end,
})

--- Typst -------------------------------------------------------------------
-- Fold on headings. Typst headings are `=`, `==`, ... followed by a space;
-- requiring the space keeps `==` inside code blocks from opening a fold.
function _G.typst_foldexpr()
  local level = vim.fn.getline(vim.v.lnum):match("^(=+)%s")
  if level then
    return ">" .. #level
  end
  return "="
end

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("TypstFold"),
  pattern = "typst",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.typst_foldexpr()"
    vim.opt_local.foldlevel = 99 -- start with everything open
  end,
})
