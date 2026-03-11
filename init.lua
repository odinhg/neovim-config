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

-- Folding for Typst headings (move to separate file later)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.typst_foldexpr()"
  end,
})

function _G.typst_foldexpr()
  local line = vim.fn.getline(vim.v.lnum)
  local level = line:match("^(=+)")
  if level then
    return ">" .. #level
  end
  return "="
end

