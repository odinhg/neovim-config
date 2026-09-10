-- Global key mappings. Leader keys are set in init.lua, before lazy.nvim runs.

local function map(mode, lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", { noremap = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Move by screen line over wrapped prose, but keep counts (5j) linewise.
map("n", "k", "v:count == 0 ? 'gk' : 'k'", "Up (screen line)", { expr = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", "Down (screen line)", { expr = true })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")

--- Telescope ---------------------------------------------------------------
map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, "Find files")
map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, "Live grep")
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, "Buffers")
map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, "Help tags")
map("n", "<leader>fd", function() require("telescope.builtin").diagnostics() end, "Diagnostics")
map("n", "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, "Document symbols")
-- Jump between thesis sections: Typst headings show up as document symbols.
map("n", "<leader>fr", function() require("telescope.builtin").resume() end, "Resume last picker")

--- Files / terminal / git --------------------------------------------------
map("n", "<leader>n", "<cmd>Neotree toggle<CR>", "File tree")
map("n", "<leader>ft", "<cmd>ToggleTerm<CR>", "Toggle terminal")
map("n", "<leader>lg", "<cmd>LazyGit<CR>", "LazyGit")

--- Buffers (barbar) --------------------------------------------------------
for i = 1, 9 do
  map("n", "<leader>" .. i, "<cmd>BufferGoto " .. i .. "<CR>", "Go to buffer " .. i)
end
map("n", "<leader>0", "<cmd>BufferLast<CR>", "Go to last buffer")
map("n", "<leader><Right>", "<cmd>BufferNext<CR>", "Next buffer")
map("n", "<leader><Left>", "<cmd>BufferPrevious<CR>", "Previous buffer")
map("n", "<leader>bd", "<cmd>BufferClose<CR>", "Close buffer")

--- Writing -----------------------------------------------------------------
map("n", "<leader>tp", "<cmd>TypstPreviewToggle<CR>", "Typst: toggle preview")

-- Toggle harper-ls when you want to draft without being corrected. Stopping
-- the client clears its diagnostics; starting it re-lints the buffer.
map("n", "<leader>tg", function()
  local on = not vim.lsp.is_enabled("harper_ls")
  -- Disabling stops the running client, which clears its diagnostics;
  -- enabling re-runs the FileType hook and re-lints open buffers.
  vim.lsp.enable("harper_ls", on)
  vim.notify("harper-ls: " .. (on and "on" or "off"))
end, "Toggle grammar checking")
