-- plugins/specs/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "onedark",
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "oil", "yazi", "Trouble", "lazy", "mason" },
      always_divide_middle = true, -- ✅ Предотвращает поломку layout при узких окнах
    },

    sections = {
      lualine_a = {
        {
          "mode",
          fmt = function(str) return str:sub(1, 1) end,
        },
      },
      lualine_b = {
        { "branch", icon = "" },
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          colored = true, -- ✅ Цвета git-статуса из темы
        },
      },
      lualine_c = {
        {
          "filename",
          path = 1,
          symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
        },
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = " ", warn = " ", info = " ", hint = "󰌶 " }, -- ✅ NF v3 compatible
        },
      },
      lualine_x = {
        {
          "encoding",
          cond = function() return vim.bo.fenc ~= "utf-8" and vim.bo.fenc ~= "" end,
        },
        {
          "fileformat",
          symbols = { unix = "LF", dos = "CRLF", mac = "CR" },
        },
        { "filetype", icon_only = false },
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },

    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", path = 0 } }, -- ✅ Только имя в неактивных окнах
      lualine_x = { { "location" } },
      lualine_y = {},
      lualine_z = {},
    },

    extensions = { "lazy", "mason", "trouble", "quickfix", "oil" }, -- ✅ Убран несовместимый "fzf"
  },
}
