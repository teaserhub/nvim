-- ~/.config/nvim/lua/plugins/treesitter.lua
return {
	-- 1️⃣ Treesitter: подсветка синтаксиса на основе AST
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", -- компилирует парсеры при установке/обновлении
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.config").setup({
				ensure_installed = {
					-- 🎯 Твой стек
					"go",
					"c",
					"cpp",
					"rust",
					"lua",
					"javascript",
					"typescript",
					"html",
					"css",
					"json",
					"bash",
					"markdown",
					"vim",
					"vimdoc",
				},
				highlight = { enable = true },
				indent = { enable = true }, -- умные отступы по синтаксису
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-Space>", -- начать выделение
						node_incremental = "<C-Space>", -- расширить выделение
						node_decremental = "<BS>", -- сузить выделение
					},
				},
				-- Авто-пары отключены здесь, чтобы не конфликтовать с mini.pairs
				autopairs = { enable = false },
			})
		end,
	},

	-- 2️⃣ Визуальные отступы (вертикальные линии как в VS Code)
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		main = "ibl",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = { enabled = true },
			-- ✅ v3 API: исключение по типам файлов
			exclude = {
				filetypes = { "oil", "terminal", "help", "lazy", "mason", "fzf" },
			},
		},
	},

	-- 3️⃣ Умные авто-скобки/кавычки (лёгкий и быстрый)
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		config = function()
			require("mini.pairs").setup({
				modes = { insert = true, command = true },
				skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
				skip_ts = { "string" },
				skip_unbalanced = true,
			})
		end,
	},
}
