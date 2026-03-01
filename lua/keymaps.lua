-- Keymaps extracted from init.lua
local M = {}

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Clipboard
vim.o.clipboard = "unnamedplus"
map("v", "<leader>y", "+y", { noremap = true, silent = true })
map("n", "<leader>y", "+yy", { noremap = true, silent = true })

-- Better movement for wrapped lines
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Telescope keymaps (require on use)
map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Telescope: find files" })
map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Telescope: live grep" })
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Telescope: buffers" })
map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Telescope: help tags" })

-- Neo-tree
vim.api.nvim_set_keymap("n", "<leader>n", ":Neotree toggle<CR>", { noremap = true, silent = true })

-- CodeCompanion keymaps
map({ "n", "v" }, "<leader>ck", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
map({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
map("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
vim.cmd([[cab cc CodeCompanion]])

-- Toggleterm
map("n", "<leader>ft", ":ToggleTerm<CR>", { noremap = true, silent = true })

-- barbar keymaps
for i = 1, 9 do
  vim.api.nvim_set_keymap("n", "<leader>" .. i, ":BufferGoto " .. i .. "<CR>", { noremap = true, silent = true })
end
vim.api.nvim_set_keymap("n", "<leader>0", ":BufferLast<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><Right>", ":BufferNext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><Left>", ":BufferPrevious<CR>", { noremap = true, silent = true })

-- LazyGit
map("n", "<leader>lg", ":LazyGit<CR>", { noremap = true, silent = true })

return M
