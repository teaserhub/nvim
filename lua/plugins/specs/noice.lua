-- ~/.config/nvim/lua/plugins/ui/noice.lua
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- 🔍 LSP: только hover, signature отдаём blink.cmp
    lsp = {
      hover = { enabled = true, view = "popup" },
      signature = { enabled = false },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },

    cmdline = { enabled = true, view = "cmdline_popup" },
    popupmenu = { enabled = false }, -- blink.cmp остаётся единственным

    -- 🎨 Визуальные параметры
    views = {
      popup = {
        border = { style = "rounded" },
        size = { max_width = 85, max_height = 20 },
        padding = { 1, 3 }, -- {vertical, horizontal} валидный nui-формат
        focusable = true,   -- ✅ Позволяет скроллить и копировать текст
      },
      cmdline_popup = {
        border = { style = "rounded" },
        padding = { 1, 2 },
        position = { row = "40%", col = "50%" },
        size = { min_width = 60 },
      },
      notify = {
        max_width = 60,
        stages = "fade_in_slide_out",
      },
      split = { enter = true },
    },

    -- 🗺️ Маршрутизация: убираем шум, длинные логи → split
    routes = {
      { filter = { event = "lsp", kind = "progress" }, opts = { skip = true } },
      { filter = { find = "No information available" }, opts = { skip = true } },
      { filter = { event = "msg_show", find = "written" }, opts = { skip = true } },
      { filter = { event = "msg_show", find = "%d+L, %d+B" }, opts = { skip = true } },
      { filter = { event = "msg_show", find = "^/" }, opts = { skip = true } },
      { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
      { filter = { event = "msg_show", min_height = 8 }, view = "split" },
    },

    -- ⚙️ Глобальные ограничения
    throttle = 16, -- ~60Hz debounce, нет лагов при быстром вводе
  },
}
