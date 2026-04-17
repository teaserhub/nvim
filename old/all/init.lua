-- ====================== Bootstrap lazy.nvim ======================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ====================== Основные настройки ======================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opts = {
  number = true,
  relativenumber = true,
  tabstop = 4,
  shiftwidth = 4,
  expandtab = true,
  smartindent = true,
  wrap = false,
  termguicolors = true,
  clipboard = "unnamedplus",
  cursorline = true,
  scrolloff = 8,
  sidescrolloff = 8,
}

for k, v in pairs(opts) do
  vim.opt[k] = v
end

-- ====================== Plugins ======================
require("lazy").setup({
  -- 1. Тема Catppuccin Mocha (самая приятная)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        integrations = {
          treesitter = true,
          telescope = true,
          lsp_trouble = true,
          which_key = true,
          gitsigns = true,
          nvimtree = true,
          cmp = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- 2. Treesitter (лучшая подсветка)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "go", "gomod", "gosum", "gowork", "lua", "markdown", "markdown_inline" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- 3. Главный Go-плагин (ray-x/go.nvim)
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        goimports = "gopls",
        gofmt = "gofumpt",
        lsp_cfg = true,
        lsp_on_attach = true,
        dap_debug = true,
        luasnip = true,
      })

      -- Авто goimports + gofumpt при сохранении
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimports()
        end,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod", "gowork" },
    build = ':lua require("go.install").update_all_sync()',
  },

  -- 4. Автодополнение (blink.cmp — самое быстрое в 2026)
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "*",
    config = function()
      require("blink.cmp").setup({
        keymap = { preset = "default" },
        appearance = { use_nvim_cmp_as_default = true },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
      })
    end,
  },

  -- 5. Telescope (поиск по файлам, символам и т.д.)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({})
      telescope.load_extension("fzf")
    end,
  },

  -- 6. Файловый менеджер
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 35 },
      })
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle Explorer" })
    end,
  },

  -- 7. Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "catppuccin" } })
    end,
  },

  -- 8. Дополнительные удобства
  { "lewis6991/gitsigns.nvim", config = function() require("gitsigns").setup() end },
  { "folke/which-key.nvim", config = function() require("which-key").setup() end },
  { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
})
local keymap = vim.keymap

-- Leader
vim.g.mapleader = " "

-- Insert
keymap.set('i','jj','<Esc>')

-- Buffers
keymap.set('n','<leader>w',':w<CR>')
keymap.set('n','<leader>q',':q<CR>')

-- Neo-tree
keymap.set('n','<leader>e',':Neotree left toggle reveal<CR>')

-- Navigation
keymap.set('n','<c-k>',':wincmd k<CR>')
keymap.set('n','<c-j>',':wincmd j<CR>')
keymap.set('n','<c-h>',':wincmd h<CR>')
keymap.set('n','<c-l>',':wincmd l<CR>')

-- Splits 
keymap.set('n','|',':vsplit<CR>')
keymap.set('n','\\',':split <CR>')

-- Tabs 
keymap.set('n','<Tab>',':BufferLineCycleNext<CR>')
keymap.set('n','<s-Tab>',':BufferLineCyclePrev<CR>')
keymap.set('n','<leader>x',':BufferLinePickClose<CR>')
keymap.set('n','<c-x>',':BufferLineCloseOthers<CR>')

-- ====================== LSP Keymaps ======================
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })

-- ====================== Telescope Keymaps ======================
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Buffers" })

-- ====================== Go-specific ======================
vim.keymap.set("n", "<leader>gt", ":GoTest<CR>", { desc = "Go Test" })
vim.keymap.set("n", "<leader>gc", ":GoCoverage<CR>", { desc = "Go Coverage" })
vim.keymap.set("n", "<leader>gr", ":GoRun<CR>", { desc = "Go Run" })
vim.keymap.set("n", "<leader>gb", ":GoBuild<CR>", { desc = "Go Build" })
