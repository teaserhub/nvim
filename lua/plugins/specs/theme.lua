-- ~/.config/nvim/lua/plugins/theme.lua
-- https://github.com/topics/neovim-colorscheme
return {
	-- 1️⃣ Иконки файлов (используются bufferline, lualine, oil, fzf)
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},

	-- 2️⃣ Цветовая схема OneDark Pro
	{
		"navarasu/onedark.nvim",
		priority = 1000, -- загрузить раньше всех
		lazy = false, -- загрузить сразу, не ждать событий
		config = function()
			require("onedark").setup({
				style = "warm", -- 🎨 "dark" | "darker" | "cool" | "deep" | "warm" | "warmer"
				transparent = false, -- true = прозрачный фон
				terminal_colors = true, -- синхронизация цветов с :terminal
				diagnostics = {
					darker = true, -- сделать цвета ошибок темнее
					undercurl = true, -- волнистое подчёркивание ошибок
					background = true, -- фон у диагностических сообщений
				},
				-- 🔗 Интеграция с плагинами
				highlight_groups = {
					-- Bufferline
					BufferLineFill = { bg = "#1e222a" },
					BufferLineBufferSelected = { bg = "#282c34", fg = "#abb2bf", bold = true },
					-- Lualine
					StatusLine = { bg = "#282c34", fg = "#abb2bf" },
					-- Cursor line
					CursorLine = { bg = "#2c313c" },
					-- Search highlight
					IncSearch = { bg = "#e5c07b", fg = "#282c34", bold = true },
				},
				-- Отключение отдельных подсветок (если мешают)
				disable = {
					background = false,
					term_colors = false,
					eol = false,
				},
			})
			vim.cmd.colorscheme("onedark")
		end,
	},
}
