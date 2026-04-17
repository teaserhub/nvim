-- ~/.config/nvim/lua/plugins/ui.lua
return {
  -- 1️⃣ Bufferline: вкладки буферов (как в VS Code)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Следующий буфер" },
      { "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Предыдущий буфер" },
      { "<leader>bc", "<cmd>bdelete<cr>", desc = "Закрыть текущий буфер" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Закрыть остальные буферы" },
    },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers", -- показываем буферы, а не табы
          separator_style = "slant", -- стиль разделителей
          show_buffer_close_icons = true,
          show_buffer_icons = true,
          diagnostics = "nvim_lsp", -- показывает ошибки LSP на вкладках
          always_show_bufferline = true,
          offsets = {
            { filetype = "oil", text = "Oil", highlight = "Directory", text_align = "left" },
          },
        },
      })
    end,
  },

  -- 2️⃣ Lualine: строка состояния снизу
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto", -- подхватывает текущую цветовую схему
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true, -- статусбар на всю ширину даже в сплитах
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
}
