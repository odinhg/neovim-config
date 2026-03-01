-- Markdown renderer and CodeCompanion
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    opts = {
      file_types = { "markdown" },
    },
    ft = { "markdown" },
  },
  {
    "olimorris/codecompanion.nvim",
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = { adapter = "openrouter" },
          inline = { adapter = "openrouter" },
        },
        adapters = {
          http = {
            openrouter = function()
              return require("codecompanion.adapters").extend("openai_compatible", {
                env = {
                  url = "https://openrouter.ai/api",
                  api_key = "OPENROUTER_API_KEY",
                  chat_url = "/v1/chat/completions",
                },
                schema = {
                  model = {
                    default = "openai/gpt-5-mini",
                    choices = {
                      ["google/gemini-2.0-flash-001"] = {},
                      ["google/gemini-2.5-pro-preview-03-25"] = {},
                      ["anthropic/claude-3.7-sonnet"] = {},
                      ["anthropic/claude-3.5-sonnet"] = {},
                      ["openai/gpt-4o-mini"] = {},
                      ["deepseek/deepseek-v3.2"] = {},
                      ["openai/gpt-5-mini"] = {},
                    },
                  },
                },
              })
            end,
          },
        }
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  { "lifepillar/vim-gruvbox8" },
}
