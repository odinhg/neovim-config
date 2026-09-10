require("copilot").setup({
  suggestion = {
    -- Must be enabled for the inline ghost text to exist at all; the <Tab>
    -- and <S-Tab> handlers in config/cmp.lua are what accept it, which is why
    -- Copilot's own accept keymaps are turned off.
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = false,
      accept_word = false,
    },
  },
  -- Copilot's completions are noise inside prose.
  filetypes = {
    typst = false,
    markdown = false,
    tex = false,
    gitcommit = false,
    ["*"] = true,
  },
})
