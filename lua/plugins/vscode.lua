-- lua/plugins/theme-vscode.lua
return {
  "Mofiqul/vscode.nvim",
  priority = 1000,
  config = function()
    local vscode = require("vscode")

    vscode.setup({
      -- Основные настройки
      style = "dark",           -- dark / light
      transparent = false,      -- сделай true, если хочешь прозрачный фон
      italic_comments = true,
      underline_links = true,
      disable_nvimtree_bg = true,

      -- Группы цветов, которые можно дополнительно настроить
      color_overrides = {},
      group_overrides = {},
    })

    -- Активируем тему
   -- vim.cmd.colorscheme("vscode")
  end,
}
