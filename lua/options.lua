-- General editor options.

local opt = vim.opt

-- Search
opt.hlsearch = false
opt.ignorecase = true
opt.smartcase = true

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.mouse = "a"
opt.breakindent = true
opt.termguicolors = true
opt.scrolloff = 4
opt.splitbelow = true
opt.splitright = true

-- Files & behaviour
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.clipboard = "unnamedplus"
opt.completeopt = "menuone,noselect"
opt.confirm = true

-- Indentation defaults
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.autoindent = true
opt.smartindent = true

-- Per-filetype indentation. Anything not listed keeps the defaults above.
local ft_indent = {
  css = 2,
  html = 2,
  javascript = 2,
  json = 2,
  lua = 2,
  markdown = 2,
  toml = 2,
  typescript = 2,
  typst = 2,
  yaml = 2,
}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserIndent", { clear = true }),
  callback = function(ev)
    local width = ft_indent[vim.bo[ev.buf].filetype]
    if width then
      vim.bo[ev.buf].shiftwidth = width
      vim.bo[ev.buf].tabstop = width
      vim.bo[ev.buf].softtabstop = width
      vim.bo[ev.buf].expandtab = true
    end
  end,
})

-- Colorscheme. Guarded so a missing/failed colorscheme plugin doesn't abort
-- the rest of startup.
opt.background = "dark"
if not pcall(vim.cmd.colorscheme, "duckbones") then
  vim.notify("colorscheme 'duckbones' not found, falling back to default", vim.log.levels.WARN)
end
