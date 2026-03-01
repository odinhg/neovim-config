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
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
}
