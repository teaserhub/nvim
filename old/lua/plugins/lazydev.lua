-- lua/plugins/lazydev.lua  (отдельный файл, не в dependencies blink!)
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
  },
}
