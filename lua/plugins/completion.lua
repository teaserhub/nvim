-- lua/plugins/completion.lua
return {
  "saghen/blink.cmp",
  lazy = false,
  version = "*",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    require("blink.cmp").setup({
      keymap = {
        preset = "super-tab",     -- ← Это самое важное изменение
        -- Альтернатива: "enter" если хочешь принимать Enter'ом
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      completion = {
        menu = {
          border = "rounded",
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "rounded" },
        },
        ghost_text = { enabled = true },
      },

      signature = { enabled = true, window = { border = "rounded" } },

      -- Настройка поведения Enter и Tab
      cmdline = { enabled = false },
    })
  end,
}
