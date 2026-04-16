-- lua/plugins/statusline.lua
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "catppuccin",
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        globalstatus = true,           -- одна строка на всё
        refresh = { statusline = 100 },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { 
          {
            "filename",
            path = 1,                  -- показывает относительный путь
            symbols = { modified = "●", readonly = "󰌾" },
          }
        },
        lualine_x = { "diagnostics", "filetype", "encoding" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      -- Вкладки (табы) внизу — чисто и минималистично
      tabline = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "buffers", mode = 2, show_filename_only = true } },  -- ← здесь вкладки
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "neo-tree", "lazy" },
    })
  end,
}
