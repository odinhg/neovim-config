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

--  Plugin setup using Lazy.nvim
require("lazy").setup({
  -- Core dependencies
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
              ["<esc>"] = actions.close
            },
          },
        },
      })

    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate", -- runs only when you update plugins
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "typst", "python", "cpp", "bash", "vim", "markdown", "markdown_inline", "html", "latex", "yaml" }, -- choose what you actually need
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  {
		"nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      vim.g.no_plugin_maps = true
    end,
  },

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'gruvbox',
          -- sleek powerline separators (make sure your font supports these glyphs)
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          always_divide_middle = false,
          globalstatus = true,
          disabled_filetypes = { statusline = { 'neo-tree' } },
          refresh = { statusline = 1000 },
        },
        sections = {
          -- compact single-letter mode indicator
          lualine_a = { { 'mode', fmt = function(str) return ' ' .. (str:sub(1,1)) .. ' ' end } },
          -- git + diff
          lualine_b = {
            { 'branch', icon = '' },
            { 'diff', colored = true, symbols = { added = '✚', modified = '✱', removed = '✖' } },
          },
          -- filename with path (level 1)
          lualine_c = { { 'filename', file_status = true, path = 1 } },
          -- diagnostics + active LSP client
          lualine_x = {
            { 'diagnostics', sources = { 'nvim_lsp' }, symbols = { error = ' ', warn = ' ', info = ' ' } },
          },
          -- lightweight right side
          lualine_y = { 'filetype', { function() return os.date("%H:%M:%S") end } },
          lualine_z = { 'progress', 'location' },
        },
        inactive_sections = {
          lualine_a = {}, lualine_b = {}, lualine_c = { 'filename' }, lualine_x = { 'location' }, lualine_y = {}, lualine_z = {}
        },
        extensions = { 'neo-tree', 'lazy' },
      })
    end,
  },

  -- Indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "┊" },
      exclude = { filetypes = { "help", "packer" }, buftypes = { "terminal", "nofile" } },
    },
  },

  -- Git & UI
  { "lewis6991/gitsigns.nvim" },
  { "romgrk/barbar.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("barbar").setup({
        icons = {
          filetype = {
            enabled = true,
            colored = true,
          },
        },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
  },
  { 
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
  },

  -- Toggle Terminal
  {"akinsho/toggleterm.nvim", version = "*", config = true},

  -- LaTeX
  { "lervag/vimtex" },

  -- Typst
  {
    'chomosuke/typst-preview.nvim',
    lazy = false, -- or ft = 'typst'
    version = '1.*',
    opts = {}, -- lazy.nvim will implicitly calls `setup {}`
    config = function()
      require('typst-preview').setup({
        debug = true,
        port = 8080
      })
    end,
  },

  -- Completion & LSP
  {
    "zbirenbaum/copilot.lua",
    requires = {
      "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
    },
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            -- Keymaps are setup below in nvim-cmp config 
            accept = false, 
            accept_word = false, 
          },
        }
      })
    end,
  },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },

  -- Pretty Markdown render
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { "markdown"},
    },
    ft = { "markdown"},
  },
  -- Codecompanion
  {
    "olimorris/codecompanion.nvim",
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "openrouter",
          },
          inline = {
            adapter = "openrouter",
          },
        },
        adapters = {
          http = {
            openrouter = function()
              return require("codecompanion.adapters").extend("openai_compatible", {
                env = {
                  url = "https://openrouter.ai/api",
                  api_key = "OPENROUTER_API_KEY",
                  chat_url = "/v1/chat/completions",
                },
                schema = {
                  model = {
                    default = "openai/gpt-5-mini",
                    choices = {
                      ["google/gemini-2.0-flash-001"] = {},
                      ["google/gemini-2.5-pro-preview-03-25"] = {},
                      ["anthropic/claude-3.7-sonnet"] = {},
                      ["anthropic/claude-3.5-sonnet"] = {},
                      ["openai/gpt-4o-mini"] = {},
                      ["deepseek/deepseek-v3.2"] = {},
                      ["openai/gpt-5-mini"] = {},
                    },
                  },
                },
              })
            end,
          },
        }
      })

      -- keymaps moved to Keymaps section
    end,

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  -- gruvbox 8 colorscheme
	{ "lifepillar/vim-gruvbox8" },
})

-----------------------------------------------------------
--  Custom configuration and keymaps
-----------------------------------------------------------

-- Search & editing options
vim.o.hlsearch = false                         -- disable highlight search
vim.wo.number = true                          -- show line numbers
vim.wo.relativenumber = true                  -- show relative line numbers
vim.o.mouse = "a"                             -- enable mouse support in all modes
vim.o.breakindent = true                      -- maintain indent on wrapped lines
vim.opt.undofile = true                       -- persistent undo
vim.o.ignorecase = true                       -- case-insensitive search
vim.o.smartcase = true                        -- case-sensitive if uppercase present
vim.o.updatetime = 250                        -- time before swap file writes (ms)
vim.wo.signcolumn = "yes"                     -- always show sign column
vim.o.completeopt = "menuone,noselect"        -- completion menu behavior

-- Keymaps / Bindings
-- Leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Copy to system clipboard
--vim.keymap.set("v", "<leader>y", ":'<,'>w !xclip -sel clip<CR>", { silent = true }) -- Visual mode yank to system clipboard
--vim.keymap.set("n", "<leader>y", ': .w !xclip -sel clip<CR>', { silent = true }) -- Normal mode yank current line to system clipboard
-- Use system clipboard if available
vim.o.clipboard = "unnamedplus"

-- Copy to system clipboard (safe, uses + register)
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>y", '"+yy', { noremap = true, silent = true })

-- Better movement for wrapped lines
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Telescope keymaps (require on use)
vim.keymap.set("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Telescope: find files" })
vim.keymap.set("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Telescope: live grep" })
vim.keymap.set("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Telescope: buffers" })
vim.keymap.set("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Telescope: help tags" })

-- Neo-tree
vim.api.nvim_set_keymap("n", "<leader>n", ":Neotree toggle<CR>", { noremap = true, silent = true })

-- CodeCompanion keymaps
vim.keymap.set({ "n", "v" }, "<leader>ck", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

-- Toggleterm
vim.keymap.set("n", "<leader>ft", ":ToggleTerm<CR>", { noremap = true, silent = true }) 

-- barbar keymaps
vim.api.nvim_set_keymap("n", "<leader>1", ":BufferGoto 1<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>2", ":BufferGoto 2<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>3", ":BufferGoto 3<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>4", ":BufferGoto 4<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>5", ":BufferGoto 5<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>6", ":BufferGoto 6<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>7", ":BufferGoto 7<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>8", ":BufferGoto 8<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>9", ":BufferGoto 9<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>0", ":BufferLast<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><Right>", ":BufferNext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><Left>", ":BufferPrevious<CR>", { noremap = true, silent = true })

-- LazyGit
vim.keymap.set("n", "<leader>lg", ":LazyGit<CR>", { noremap = true, silent = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({timeout = 500})
    end,
})


-- LaTeX settings
vim.g.vimtex_view_method = "zathura"
vim.g.maplocalleader = ","
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_compiler_latexmk = {
  options = {
    "-verbose",
    "-file-line-error",
    "-synctex=1",
    "-interaction=nonstopmode",
    "-shell-escape",
  },
}

-- Minimal LSP config
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})



-- nvim-cmp
local cmp = require("cmp")
cmp.setup({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
  }),
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-l>"] = cmp.mapping.confirm({ select = true }),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept_word()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  }),
})

-- Default settings
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.shiftwidth = 4        -- Default number of spaces per indent
vim.opt.tabstop = 4           -- Number of spaces for a tab
vim.opt.softtabstop = 4       -- Number of spaces for a soft tab
vim.opt.autoindent = true     -- Automatically indent new lines
vim.opt.smartindent = true     -- Smart indentation for programming languages

-- Filetype-specific indentation
local ft_settings = {
  lua = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  python = { shiftwidth = 4, tabstop = 4, softtabstop = 4 },
  html = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  css  = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  markdown = { expandtab = true }, -- just spaces, no fixed width
  cpp  = { shiftwidth = 4, tabstop = 4, softtabstop = 4 },
  yaml = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  json = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  typst = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  typescript = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
  javascript = { shiftwidth = 2, tabstop = 2, softtabstop = 2 },
}
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*", -- all filetypes
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
--vim.cmd("colorscheme retrobox")
vim.cmd("colorscheme gruvbox8_hard") 
vim.api.nvim_set_option("background", "dark")

