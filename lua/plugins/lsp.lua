-- LSP, tool management and completion.
--
-- Load order matters: mason.nvim prepends its bin directory to $PATH during
-- setup, so it must run before any server is started by name (tinymist,
-- harper-ls and ruff live in mason's bin dir, not on the system PATH).
return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    priority = 100,
    opts = {},
  },

  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      -- lspconfig server names, not mason package names.
      ensure_installed = { "tinymist", "harper_ls", "pyright", "ruff" },
      -- Servers are enabled explicitly in plugins/config/lsp.lua so that the
      -- settings there are guaranteed to be registered first.
      automatic_enable = false,
    },
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      require("plugins.config.lsp")
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      require("plugins.config.cmp")
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    dependencies = { "copilotlsp-nvim/copilot-lsp" },
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("plugins.config.copilot")
    end,
  },
}
