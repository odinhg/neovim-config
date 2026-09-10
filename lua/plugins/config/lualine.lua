require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    always_divide_middle = false,
    globalstatus = true,
    disabled_filetypes = { statusline = { "neo-tree" } },
    refresh = { statusline = 1000 },
  },
  sections = {
    lualine_a = { { "mode", fmt = function(str) return " " .. (str:sub(1, 1)) .. " " end } },
    lualine_b = {
      { "branch", icon = "" },
      { "diff", colored = true, symbols = { added = "✚", modified = "✱", removed = "✖" } },
    },
    lualine_c = { { "filename", file_status = true, path = 1 } },
    lualine_x = {
      -- Live word count for prose buffers -- handy for tracking thesis length.
      {
        function()
          local wc = vim.fn.wordcount()
          return (wc.visual_words or wc.words) .. " words"
        end,
        cond = function()
          return vim.tbl_contains({ "typst", "markdown", "tex", "text" }, vim.bo.filetype)
        end,
      },
      { "diagnostics", sources = { "nvim_lsp" }, symbols = { error = " ", warn = " ", info = " " } },
    },
    lualine_y = { "filetype", { function() return os.date("%H:%M:%S") .. " :)" end } },
    lualine_z = { "progress", "location" },
  },
  inactive_sections = {
    lualine_a = {}, lualine_b = {}, lualine_c = { "filename" }, lualine_x = { "location" }, lualine_y = {}, lualine_z = {},
  },
  extensions = { "neo-tree", "lazy" },
})
