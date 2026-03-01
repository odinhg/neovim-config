--  Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugin list (plugins are defined in lua/plugins.lua)
require("lazy").setup(require("plugins"))

-- Load modular configuration
require("options")
require("keymaps")
require("autocmds")

-- Load completion config if present (after plugins are loaded)
pcall(require, "completion")

