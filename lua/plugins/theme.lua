-- ~/.config/nvim/lua/plugins/theme.lua
return {
	-- 1️⃣ Иконки файлов (используются bufferline, lualine, oil, fzf)
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},

	-- 2️⃣ Цветовая схема Tokyonight (оптимизирована под Neovim)
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- загрузить раньше всех
		lazy = false, -- загрузить сразу, не ждать событий
		config = function()
			require("tokyonight").setup({
				style = "storm", -- 🎨 "night" | "storm" | "day" | "moon"
				transparent = false, -- true = прозрачный фон (для терминалов/tiling WM)
				terminal_colors = true, -- синхронизация цветов с :terminal
				styles = {
					comments = { italic = true },
					keywords = { italic = false },
					functions = {},
					variables = {},
				},
				-- 🔗 Интеграция с bufferline и lualine
				on_highlights = function(hl, c)
					hl.BufferLineFill = { bg = c.bg_dark }
					hl.BufferLineBufferSelected = { bg = c.bg_highlight, fg = c.fg, bold = true }
				end,
			})
			vim.cmd.colorscheme("tokyonight")
		end,
	},
}
