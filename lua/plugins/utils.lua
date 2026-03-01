-- Utilities: toggleterm, vimtex, typst-preview
return {
  {"akinsho/toggleterm.nvim", version = "*", config = true},
  { "lervag/vimtex" },
  {
    'chomosuke/typst-preview.nvim',
    lazy = false,
    version = '1.*',
    opts = {},
    config = function()
      require('typst-preview').setup({
        debug = true,
        port = 8080,
      })
    end,
  },
}
