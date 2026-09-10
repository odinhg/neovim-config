return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "┊" },
      exclude = {
        -- Indent guides are noise in prose.
        filetypes = {
          "help", "lazy", "mason", "neo-tree", "toggleterm",
          "typst", "markdown", "tex", "text", "gitcommit",
        },
        buftypes = { "terminal", "nofile" },
      },
    },
  },
}
