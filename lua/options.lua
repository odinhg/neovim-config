-- Options and basic settings
local M = {}

-- Search & editing options
vim.o.hlsearch = false
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.mouse = "a"
vim.o.breakindent = true
vim.opt.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"
vim.o.completeopt = "menuone,noselect"

-- Default settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Filetype-specific indentation
local ft_settings = {
  lua = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  python = { shiftwidth = 4, tabstop = 4, softtabstop = 4 },
  html = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  css  = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  markdown = { expandtab = true },
  cpp  = { shiftwidth = 4, tabstop = 4, softtabstop = 4 },
  yaml = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  json = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  typst = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  typescript = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  javascript = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    local opts = ft_settings[vim.bo.filetype]
    if opts then
      for k, v in pairs(opts) do
        vim.bo[k] = v
      end
    end
  end,
})

-- Colorscheme
vim.cmd("colorscheme gruvbox8_hard")
vim.api.nvim_set_option("background", "dark")

return M
