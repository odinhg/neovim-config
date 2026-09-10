-- nvim-treesitter, `main` branch.
--
-- Note: on this branch `setup()` accepts only `install_dir`. There is no
-- `ensure_installed`, `highlight` or `indent` option -- passing them is a
-- silent no-op. Parsers are installed with `install()`, and highlighting and
-- indentation are enabled per-buffer via Neovim's own Treesitter API.
local ts = require("nvim-treesitter")

local ensure_installed = {
  "bash",
  "c",
  "cpp",
  "css",
  "diff",
  "gitcommit",
  "html",
  "json",
  "latex",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "toml",
  "typst",
  "vim",
  "vimdoc",
  "yaml",
}

local installed = ts.get_installed("parsers")
local missing = vim.tbl_filter(function(lang)
  return not vim.tbl_contains(installed, lang)
end, ensure_installed)

if #missing > 0 then
  ts.install(missing)
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
    if not lang or not vim.tbl_contains(ts.get_installed("parsers"), lang) then
      return
    end

    -- Fails for e.g. a parser/Neovim version mismatch; a broken parser should
    -- not break opening the file.
    if not pcall(vim.treesitter.start, ev.buf, lang) then
      return
    end

    -- Only take over indentation where a language actually ships an indent
    -- query, otherwise Neovim's built-in indenting is better than nothing.
    if vim.treesitter.query.get(lang, "indents") then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
