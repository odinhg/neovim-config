-- Terminal, LaTeX and Typst tooling.
return {
  { "akinsho/toggleterm.nvim", version = "*", cmd = "ToggleTerm", opts = {} },

  {
    "lervag/vimtex",
    -- Upstream explicitly asks not to lazy-load VimTeX; it already only does
    -- work on tex buffers.
    lazy = false,
    -- These globals are read when the plugin loads, so they must be set in
    -- `init` (which lazy.nvim runs first), not from a later module.
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-shell-escape",
        },
      }
    end,
  },

  {
    "chomosuke/typst-preview.nvim",
    version = "1.*",
    ft = "typst",
    cmd = { "TypstPreview", "TypstPreviewToggle" },
    config = function()
      require("plugins.config.typst_preview")
    end,
  },
}
