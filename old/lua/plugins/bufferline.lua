-- lua/plugins/bufferline.lua
return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers",
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = true,
        numbers = "ordinal",

        tab_size = 22,
        padding = 2,                    -- увеличил
        enforce_regular_tabs = true,

        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,

        offsets = {
          {
            filetype = "neo-tree",
            text = "   Neo-tree",
            highlight = "Directory",
            separator = true,
            padding = 20,
          },
        },
      },

      highlights = {
        buffer_selected = {
          bold = true,
          italic = false,
        },
        separator_selected = {
          fg = "#1e1e2e",
        },
        buffer = {
          fg = "#a6adc8",
        },
      },
    })

    -- Клавиши
    vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Next Buffer" })
    vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
    vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Close Buffer" })
    vim.keymap.set("n", "<leader>bp", ":BufferLinePick<CR>", { desc = "Pick Buffer" })
  end,
}
