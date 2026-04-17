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
        globalstatus = true,
        refresh = { statusline = 100, tabline = 100 },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = { modified = "●", readonly = "󰌾" },
          },
        },
        lualine_x = { "diagnostics", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      -- Вкладки сверху (tabline)
      tabline = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "buffers",
            mode = 2,                    -- показывает имя файла + иконку
            show_filename_only = false,
            show_modified_status = true,
            padding = 1,                 -- padding внутри вкладок
            max_length = vim.o.columns * 2 / 3,
            symbols = {
              modified = " ●",
              alternate_file = "",
            },
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "lazy" },
    })
  end,
}
