-- lua/plugins/theme.lua
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",           -- mocha / macchiato / frappe / latte
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,

      integrations = {
        treesitter = true,
        telescope = true,
        gitsigns = true,
        lsp_trouble = true,
        which_key = true,
        neo_tree = false,
        bufferline = false,
        noice = true,
      },

      -- Делаем подсветку ещё мягче и приятнее
      styles = {
        comments = { "italic" },
        keywords = { "italic" },
        functions = { "bold" },
        variables = {},
      },

      color_overrides = {
        mocha = {
          base = "#1e1e2e",
          mantle = "#181825",
          crust = "#11111b",
        },
      },
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}
