return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- The `main` branch has a different API from `master`; pin it explicitly so
    -- a fresh clone doesn't silently land on the old one.
    branch = "main",
    -- Upstream states main does not support lazy-loading.
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("plugins.config.treesitter")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      vim.g.no_plugin_maps = true
    end,
  },
}
