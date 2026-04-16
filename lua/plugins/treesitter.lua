-- lua/plugins/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.config").setup({
      ensure_installed = {
        "go", "gomod", "gosum", "gowork",
        "lua", "python", "javascript", "typescript",
        "html", "css", "json", "markdown", "markdown_inline"
      },

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      indent = { enable = true },

      -- Настройки для приятной и мягкой подсветки
      textobjects = { enable = true },

      -- Улучшенная подсветка для Go
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
