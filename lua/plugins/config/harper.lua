-- harper-ls: grammar and spell checking for prose.
--
-- Harper parses Typst natively (it vendors `typst-syntax`), so it understands
-- document structure: it checks prose but skips math (`$...$`), code blocks,
-- raw blocks, labels and `#import`/`#cite` arguments. That is what makes it
-- usable on a thesis, where a naive spell checker drowns you in false hits.
--
-- Dictionaries (three scopes, each with its own code action on a misspelling):
--   * user      -- ~/.config/harper-ls/dictionary.txt, global to you
--   * workspace -- .harper-dictionary.txt at the project root
--   * file      -- per-file, under ~/.local/share/harper-ls/file_dictionaries/
-- Put thesis jargon in the workspace dictionary so it lives with the thesis
-- repo; keep vocabulary you use everywhere in the user dictionary.
--
-- Settings reference: https://writewithharper.com/docs/integrations/neovim

local config_home = vim.env.XDG_CONFIG_HOME or vim.fs.joinpath(vim.env.HOME, ".config")
local data_home = vim.env.XDG_DATA_HOME or vim.fs.joinpath(vim.env.HOME, ".local", "share")

---@type vim.lsp.Config
return {
  -- lspconfig's default filetype list already includes `typst`, plus markdown,
  -- tex, gitcommit and the comment bodies of most programming languages.
  -- Repeated here only to make the writing filetypes explicit.
  filetypes = {
    "typst",
    "markdown",
    "tex",
    "gitcommit",
    "asciidoc",
    "html",
    "lua",
    "python",
    "c",
    "cpp",
    "rust",
    "sh",
    "toml",
    "yaml",
  },

  -- Anchor the workspace dictionary to the thesis repo rather than to whatever
  -- directory nvim happened to start in.
  root_markers = { ".harper-dictionary.txt", "typst.toml", ".git" },

  settings = {
    ["harper-ls"] = {
      -- These are harper's own defaults, written out so they are greppable and
      -- so the existing dictionary keeps being used.
      userDictPath = vim.fs.joinpath(config_home, "harper-ls", "dictionary.txt"),
      fileDictPath = vim.fs.joinpath(data_home, "harper-ls", "file_dictionaries"),

      dialect = "American",

      -- Grammar notes are advice, not build failures. Keeping them below
      -- WARN means tinymist's real Typst errors stay visually distinct in the
      -- sign column and in `:lua vim.diagnostic.setqflist()`.
      diagnosticSeverity = "information",

      -- Keep code-action ordering stable so "Add to dictionary" does not move
      -- around under the cursor between invocations.
      codeActions = { ForceStable = true },

      -- Don't lint the display text of links/labels.
      markdown = { IgnoreLinkTitle = true },

      -- ~700 rules ship enabled. Below are the ones worth overriding for
      -- academic prose; everything unlisted keeps harper's default.
      linters = {
        ---- Keep on: genuine errors and mechanics ----
        SpellCheck = true,
        SentenceCapitalization = true,
        RepeatedWords = true,
        UnclosedQuotes = true,
        Spaces = true,
        CapitalizePersonalPronouns = true,
        EllipsisLength = true,
        DotInitialisms = true,
        CommaFixes = true,
        NoFrenchSpaces = true,
        UseEllipsisCharacter = true,
        -- A thesis is formal register: flag "don't", "it's", "we've".
        AvoidContractions = true,
        -- Pick one and be consistent. Serial comma is the norm in American
        -- academic style; swap these two if your department says otherwise.
        OxfordComma = true,
        NoOxfordComma = false,

        ---- Off: style rules that fight academic writing ----
        -- Definitions and proofs legitimately run long.
        LongSentences = false,
        -- "may suggest", "appears to indicate" -- hedging is a claim about
        -- confidence, not a weakness, in a results chapter.
        Hedging = false,
        -- "3 of the 5 models", "2 persistence modules" should stay numeric.
        SpelledNumbers = false,
        -- Flags ordinary technical vocabulary as "boring".
        BoringWords = false,
        FillerWords = false,
        -- Typst headings are sentence case in most thesis templates.
        UseTitleCase = false,
        AvoidCurses = false,
        ToDoHyphen = false,
      },
    },
  },
}
