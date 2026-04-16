-- lua/plugins/whichkey.lua
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    wk.setup({
      preset = "modern",
      win = { border = "rounded" },
      icons = { mappings = false },
    })

    -- Красивое меню
    wk.add({
      { "<leader>f", group = "🔎 Find" },
      { "<leader>g", group = "🐹 Go" },
      { "<leader>b", group = "Buffer / Tabs" },
      { "<leader>d", group = "Debug" },
      { "<leader>t", group = "Terminal" },
      { "<leader>q", group = "Session" },
    })
  end,
}
