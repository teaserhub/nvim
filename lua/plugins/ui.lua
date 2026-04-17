-- ~/.config/nvim/lua/plugins/ui.lua
return {
  -- 1️⃣ Bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- ✅ Гарантируем, что все открытые буферы сразу попадают в строку
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function() vim.bo.buflisted = true end
      })

      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant",
          show_buffer_close_icons = true,
          show_buffer_icons = true,
          diagnostics = "nvim_lsp",
          always_show_bufferline = true,
          offsets = {
            { filetype = "oil", text = "Oil", highlight = "Directory", text_align = "left" },
          },
        },
      })
    end,
    keys = {
      { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Следующий буфер" },
      { "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Предыдущий буфер" },
      { "<leader>bc", "<cmd>bdelete<cr>", desc = "Закрыть текущий буфер" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Закрыть остальные" },
      -- 🔑 Навигация через Tab (только в Normal режиме, чтобы не ломать автодополнение)
      { "<Tab>",   "<cmd>BufferLineCycleNext<cr>", desc = "Следующий буфер (Tab)" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Предыдущий буфер (Shift+Tab)" },
    },
  },

  -- 2️⃣ Lualine (без изменений, просто для полноты)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
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
