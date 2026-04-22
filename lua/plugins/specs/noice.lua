-- ~/.config/nvim/lua/plugins/ui/noice.lua
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- ✅ PRESET: минимальная база + наши оверрайды
    presets = {
      bottom_search = false,         -- Нет search команды снизу
      command_palette = true,        -- <C-n> поиск команд
      long_message_to_split = true,  -- Длинные → split
      lsp_doc_border = true,         -- LSP doc с border
    },

    lsp = {
      hover = { enabled = true, view = "popup" },
      signature = { enabled = false }, -- blink.cmp берет на себя
      
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["vim.diagnostic.open_float"] = true, -- ✅ Диагностика в popup
      },
    },

    cmdline = { enabled = true, view = "cmdline_popup" },
    popupmenu = { enabled = false }, -- blink.cmp only

    views = {
      popup = {
        border = { style = "rounded" },
        size = { max_width = 85, max_height = 20 },
        padding = { 1, 3 },
        focusable = false,
      },
      cmdline_popup = {
        border = { style = "rounded" },
        padding = { 1, 2 },
        position = { row = "40%", col = "50%" },
        size = { min_width = 60 },
      },
      notify = {
        max_width = 60,
        stages = "fade_in_slide_out", -- ✅ Анимация появления/исчезновения
      },
      split = { 
        enter = true,                 -- Фокус при открытии split
      },
    },

    routes = {
      -- ✅ LSP спам
      { filter = { event = "lsp", kind = "progress" }, opts = { skip = true } },
      { filter = { find = "No information available" }, opts = { skip = true } },
      
      -- ✅ Файловые операции
      { filter = { event = "msg_show", find = "written" }, opts = { skip = true } },
      { filter = { event = "msg_show", find = "%d+L, %d+B" }, opts = { skip = true } },
      
      -- ✅ Поиск/счетчики
      { filter = { event = "msg_show", find = "^/" }, opts = { skip = true } },
      { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
      
      -- ✅ Длинные сообщения в split (Claude прав: 10 лучше 5)
      { filter = { event = "msg_show", min_height = 10 }, view = "split" },
    },

    throttle = 1000 / 30, -- 30 FPS
    max_length = 150,     -- ✅ Обрезаем слишком длинные сообщения
  },
}
