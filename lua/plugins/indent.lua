-- Indent guides
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "┊" },
      exclude = { filetypes = { "help", "packer" }, buftypes = { "terminal", "nofile" } },
    },
  },
}
