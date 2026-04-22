-- 🖼️ Прозрачная тонкая рамка для всех float-окон (Yazi, LSP hover, noice и т.д.)
vim.api.nvim_set_hl(0, "FloatBorder", { 
  fg = "#585b70",   -- Цвет линии (подставь свой под тему)
  bg = "NONE",      -- ✅ Убирает «жирную» подложку
  blend = 0         -- ✅ Отключает внутреннее размытие Neovim
})
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" }) -- Прозрачный фон внутри окна
