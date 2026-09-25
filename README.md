# Neovim configuration

Modular Neovim config built on [lazy.nvim](https://github.com/folke/lazy.nvim).
Tuned for Typst/LaTeX thesis writing alongside general programming.

Requires Neovim 0.11+ (uses the `vim.lsp.config`/`vim.lsp.enable` API).

## Layout

```
init.lua                    bootstrap lazy.nvim, set leader keys, load lua/ modules
lua/
  plugins.lua               collects specs from plugins/*.lua
  options.lua               editor options and per-filetype indentation
  keymaps.lua               global key mappings
  autocmds.lua              diagnostics, LspAttach maps, prose and Typst behaviour
  plugins/*.lua             one file per plugin group, auto-discovered
  plugins/config/*.lua      per-plugin setup modules, required from a spec's `config`
```

`lua/plugins.lua` only scans `lua/plugins/` itself, so `plugins/config/` is not
mistaken for spec files. If a spec file fails to load, the error is reported
with its file and line rather than silently dropping the plugins it declares.

### Adding a plugin

1. Add a spec to an existing `lua/plugins/*.lua`, or create a new file that
   returns a list of specs. No registration needed.
2. For non-trivial setup, put it in `lua/plugins/config/<name>.lua` and call it
   from the spec's `config` function.
3. Restart and run `:Lazy sync`.

Note that a spec with neither `opts` nor `config` never has `setup()` called.
Use `opts = {}` if the defaults are fine.

## Language servers

Servers are installed by `mason-lspconfig` (`ensure_installed` in
`lua/plugins/lsp.lua`) and configured in `lua/plugins/config/lsp.lua`.
`automatic_enable` is off so that settings are registered before anything
starts.

| Server | Filetypes | Purpose |
| --- | --- | --- |
| `tinymist` | typst | Typst language server — **disabled**, see below |
| `harper_ls` | prose + code comments | grammar and spelling |
| `pyright` | python | types |
| `ruff` | python | lint and format |

### tinymist (disabled)

tinymist's memory use grows until it takes Neovim down with it, so it is not in
the `vim.lsp.enable` list in `lua/plugins/config/lsp.lua`. Its settings block is
left intact, and `:TinymistStart` attaches it for the current session when the
completion and jump-to-definition are worth the memory.

What still works without it:

| Feature | Now provided by |
| --- | --- |
| Syntax, indent, folds | Treesitter + `lua/autocmds.lua` |
| Live preview | `:TypstPreview` (bundles its own tinymist, preview-only) |
| PDF on save | `typst compile`, from the `TypstExportPdf` autocmd |
| Spelling and grammar | harper-ls, which parses Typst natively |

Formatting is the one real loss — `typstyle` was reached through tinymist, so
there is no `gq`/format-on-save for Typst while the server is off.

For an included chapter that will not compile on its own, set the root document:

```lua
vim.g.typst_main = "/path/to/thesis/main.typ"
```

Because mason prepends its `bin` directory to `$PATH` during setup, mason.nvim
is loaded eagerly and before the others.

## Writing prose (Typst)

Typst, Markdown, LaTeX, text and gitcommit buffers soft-wrap at word boundaries
(`wrap` + `linebreak`), and `j`/`k` move by screen line. Native `'spell'` stays
off — harper-ls does the spellchecking and understands Typst syntax, so it
skips math, code, raw blocks and `#import`/`#cite` arguments instead of
flagging them.

Typst buffers fold on headings (`=`, `==`, ...), starting fully open.
lualine shows a live word count in prose buffers.

### harper-ls

Configured in `lua/plugins/config/harper.lua`. Dialect is **American** and
diagnostics are reported at `information`, so grammar notes stay visually
distinct from real Typst errors. Style rules that misfire on
academic prose (`LongSentences`, `Hedging`, `SpelledNumbers`, `BoringWords`,
`FillerWords`, `UseTitleCase`) are off; `AvoidContractions` is on for formal
register. Everything unlisted keeps harper's default.

Harper has ~700 rules — to change one, add it to the `linters` table.

**Dictionaries.** Put the cursor on a flagged word and hit `<leader>ca`:

| Action | Written to |
| --- | --- |
| Add to the user dictionary | `~/.config/harper-ls/dictionary.txt` (global) |
| Add to the workspace dictionary | `.harper-dictionary.txt` at the project root |
| Add to the file dictionary | `~/.local/share/harper-ls/file_dictionaries/` |

Prefer the **workspace** dictionary for thesis jargon so the term list lives
with the thesis repo. Entries are case-sensitive: adding `Bifiltration` does
not cover `bifiltration`.

The workspace root is the first ancestor containing `.harper-dictionary.txt`,
`typst.toml` or `.git`.

## Keymaps

Leader is `<Space>`, local leader is `,`. Everything in the **Custom** tables is
defined in this config (`lua/keymaps.lua` and the `LspAttach` block in
`lua/autocmds.lua`); the **Built-in** and plugin tables list defaults worth
knowing.

### Custom — files and search

| Key | Action |
| --- | --- |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fd` | Diagnostics (whole workspace) |
| `<leader>fs` | Document symbols — jumps between Typst headings |
| `<leader>fr` | Resume the last picker |

### Custom — buffers, tools and motion

| Key | Action |
| --- | --- |
| `<leader>1` … `<leader>9` | Go to buffer 1–9 |
| `<leader>0` | Go to the last buffer |
| `<leader><Left>` / `<Right>` | Previous / next buffer |
| `<leader>bd` | Close buffer |
| `<leader>n` | Toggle the file tree |
| `<leader>ft` | Toggle the terminal |
| `<leader>lg` | LazyGit |
| `<Esc>` | Clear search highlight |
| `j` / `k` | Move by *screen* line, so wrapped prose behaves. A count (`5j`) is still linewise |

### Writing

| Key | Action |
| --- | --- |
| `<leader>tp` | Toggle the Typst preview |
| `<leader>tg` | Toggle grammar checking (harper-ls) on and off |
| `<leader>ca` | Code action — this is how you add a word to a dictionary |
| `<leader>e` | Show the diagnostic under the cursor in a float |
| `]d` / `[d` | Next / previous diagnostic — the main way to walk harper's findings (Neovim built-in) |

### Custom — LSP (buffer-local, only once a server attaches)

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `gr` | References |
| `gR` | Rename |
| `K` | Hover |
| `<leader>ca` | Code action (normal and visual) |
| `<leader>ci` | Go to implementation |
| `<leader>cy` | Go to type definition |
| `<leader>e` | Diagnostic float |

Neovim 0.11+ binds `gra`/`gri`/`grn`/`grr`/`grt`/`grx` globally. Since `gr` is
mapped to references here, leaving them in place would make every `gr` press
wait out `timeoutlen` to see whether a longer sequence follows, so they are
deleted at startup. `<leader>ca`, `<leader>ci` and `<leader>cy` replace the
three that did something not otherwise bound.

### Custom — insert mode (completion)

| Key | Action |
| --- | --- |
| `<C-Space>` | Trigger completion |
| `<C-n>` / `<C-p>` | Next / previous item |
| `<C-y>` or `<C-l>` | Confirm |
| `<C-u>` / `<C-d>` | Scroll the docs pop up |
| `<Tab>` | Accept the Copilot suggestion (falls through if none is showing) |
| `<S-Tab>` | Accept one word of the Copilot suggestion |

Copilot is disabled in `typst`, `markdown`, `tex` and `gitcommit` buffers, so
`<Tab>` keeps its normal meaning while writing.

### Built-in Neovim defaults worth knowing

| Key | Action |
| --- | --- |
| `]d` / `[d` | Next / previous diagnostic |
| `]D` / `[D` | Last / first diagnostic in the buffer |
| `gcc` / `gc{motion}` | Toggle comment (`gc` in visual mode) |
| `gO` | Document symbol outline |
| `gx` | Open the file path or URL under the cursor |
| `]b` / `[b` | Next / previous buffer |
| `]q` / `[q` | Next / previous quickfix entry |
| `]<Space>` / `[<Space>` | Add a blank line below / above |
| `<C-s>` | Signature help (insert and visual mode) |
| `an` / `in` | Select the parent / child Treesitter node (visual and operator-pending) |
| `]n` / `[n` | Next / previous Treesitter node |
| `]N` / `[N` | Next / previous sibling node |

### Inside a Telescope picker

| Key | Action |
| --- | --- |
| `<C-n>` / `<C-p>` | Next / previous result |
| `<CR>` | Open |
| `<C-x>` / `<C-v>` / `<C-t>` | Open in a split / vsplit / tab |
| `<Tab>` / `<S-Tab>` | Toggle multi-select |
| `<C-q>` | Send results to the quickfix list |
| `<Esc>` | Close (custom — normally `<Esc>` only leaves insert mode) |
| `<C-c>` | Close |
| `<C-/>` | Show all picker mappings |

`<C-u>` and `<C-d>` are deliberately unmapped, so they keep their normal insert
behaviour of clearing the prompt rather than scrolling the preview.

### Inside the file tree

| Key | Action |
| --- | --- |
| `<CR>` / `<Space>` | Open / toggle node |
| `s` / `S` / `t` | Open in a vsplit / split / tab |
| `a` / `A` | New file / new directory |
| `r` / `d` | Rename / delete |
| `y` / `x` / `p` | Copy / cut / paste |
| `H` | Toggle hidden files |
| `/` | Fuzzy find within the tree |
| `z` | Collapse everything |
| `?` | Show all tree mappings |
| `q` | Close |

### LaTeX (VimTeX, local leader `,`)

| Key | Action |
| --- | --- |
| `,ll` | Start / stop continuous compilation |
| `,lv` | Forward search in the viewer |
| `,lt` | Table of contents |
| `,le` | Show errors |
| `,lc` | Clean auxiliary files |
| `,lk` | Stop compilation |
| `cse` / `dse` / `tse` | Change / delete / toggle the surrounding environment |
| `csc` / `dsc` | Change / delete the surrounding command |
| `cs$` / `ds$` | Change / delete the surrounding math zone |
| `ic` / `ac`, `ie` / `ae`, `i$` / `a$` | Command, environment and math text objects |
| `]]` / `[[` | Next / previous section |

VimTeX ships many more; see `:help vimtex-default-mappings`.

## Treesitter

Pinned to nvim-treesitter's `main` branch, which cannot be lazy-loaded and whose
`setup()` accepts **only** `install_dir` — there is no `ensure_installed`,
`highlight` or `indent` option. Parsers are installed via `install()` and
highlighting is started per-buffer in `lua/plugins/config/treesitter.lua`.
Treesitter indentation is only enabled for languages that ship an indent query.

Run `:TSUpdate` after updating the plugin.
