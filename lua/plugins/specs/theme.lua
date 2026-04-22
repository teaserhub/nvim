-- ~/.config/nvim/lua/plugins/specs/theme.lua
return {
  "navarasu/onedark.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("onedark").setup({
      style = "darker",
      transparent = true,
      term_colors = true,
      ending_tildes = false,
      -- lualine убери: ты используешь mini.statusline, эта опция больше не нужна

      diagnostics = {
        darker = true,
        undercurl = true,
        background = true,
      },

      code_style = {
        comments = "italic",
        keywords = "italic",
        functions = "none",
        strings = "none",
        variables = "none",
      },

      -- ✅ FIX: Явно заставляем тему делать float-окна прозрачными
      highlights = {
        FloatBorder   = { bg = "NONE", fg = "#585b70" }, -- тонкая рамка без фона
        NormalFloat   = { bg = "NONE" },                 -- прозрачный фон попапов
        Pmenu         = { bg = "NONE" },                 -- прозрачное меню комплита
        PmenuSel      = { bg = "#3e4452" },              -- выделение в меню (можно оставить цветным)

        -- Твои старые UI-переопределения
        BufferLineFill = { bg = "#1e222a" },
        BufferLineBufferSelected = { bg = "#282c34", fg = "#abb2bf", style = "bold" },
        StatusLine = { bg = "NONE", fg = "#abb2bf" },    -- ✅ тоже прозрачный под mini.statusline
        CursorLine = { bg = "#2c313c" },
        IncSearch = { bg = "#e5c07b", fg = "#282c34", style = "bold" },
      },
    })

    vim.cmd.colorscheme("onedark")
  end,
}
