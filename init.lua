-- Entry point. Keep this file thin: bootstrap lazy.nvim, then load lua/ modules.

-- Leader keys MUST be set before lazy.nvim loads any plugin, otherwise plugin
-- specs that declare `<leader>` mappings bind them to the old leader.
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specs are auto-collected from lua/plugins/*.lua
require("lazy").setup(require("plugins"), {
  change_detection = { notify = false },
})

-- Editor configuration (after plugins so colorschemes/commands exist)
require("options")
require("keymaps")
require("autocmds")
