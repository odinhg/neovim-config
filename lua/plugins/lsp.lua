-- Completion & LSP plugins
return {
  {
    "zbirenbaum/copilot.lua",
    requires = {
      "copilotlsp-nvim/copilot-lsp",
    },
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = false,
            accept_word = false,
          },
        }
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
    vim.lsp.config["tinymist"] = {
      cmd = { "tinymist" },
      filetypes = { "typst" },
      settings = {
        formatterMode = "typstyle",
        exportPdf = "onSave",
        semanticTokens = "disable",
      },
    }
    vim.lsp.enable("tinymist")
  end,
  },
  { 
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- For LSP completions
      "hrsh7th/cmp-buffer", -- For buffer completions
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "tinymist",
      },
    },
  },
}
