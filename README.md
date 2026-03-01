# Neovim configuration README

This directory contains a modular Neovim configuration using Lazy.nvim for plugin management.

Layout
- init.lua - minimal bootstrap: installs/bootstraps lazy.nvim and loads the lua/ modules.
- lua/
  - plugins/ - individual plugin specification files (loaded by `lua/plugins.lua`).
  - plugins.lua - aggregator that collects plugin specs from `lua/plugins/*.lua`.
  - options.lua - general Neovim options and filetype-specific settings.
  - keymaps.lua - global key mappings.
  - autocmds.lua - autocmds such as yank highlight and LspAttach mappings.
  - completion.lua - nvim-cmp configuration (loaded after plugins to ensure cmp is available).

Adding a plugin
1. Create a new file under `lua/plugins/`, return a table with one or more plugin specs.
2. Add your filename (without `.lua`) to the list `plugin_files` inside `lua/plugins.lua`.
3. Restart Neovim and run `:Lazy sync`.

Notes
- Each plugin spec file returns a list (table) of plugin spec tables compatible with lazy.nvim.
- Per-plugin configuration functions remain in the spec; you can move complex plugin configs to their own modules later.

If you'd like, I can:
- Add a script to auto-discover files under `lua/plugins/` instead of maintaining the `plugin_files` list.
- Move each plugin's config into `lua/plugins/config/<plugin>.lua` and `require` them from the plugin spec for cleaner separation.
