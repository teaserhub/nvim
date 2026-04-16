-- lua/plugins/completion.lua
return {
  "saghen/blink.cmp",
  lazy = false,
  version = "*",
  dependencies = { "rafamadriz/friendly-snippets" },   -- оставляем
  config = function()
    require("blink.cmp").setup({
      keymap = {
        preset = "super-tab",      -- самое удобное поведение
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      completion = {
        menu = { border = "rounded" },
        documentation = {
          auto_show = true,
          window = { border = "rounded" },
        },
        ghost_text = { enabled = true },
      },

      signature = { enabled = true, window = { border = "rounded" } },
    })
  end,
}
