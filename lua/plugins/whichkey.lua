return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		icons = {
			breadcrumb = "»",
			separator = "➜",
			group = "+",
		},
		win = {
			border = "rounded",
			padding = { 1, 2 },
			title_pos = "center",
		},
		-- Показывать подсказки при нажатии <leader>
		triggers = { { "<leader>", mode = { "n", "v" } } },
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Локальные хоткеи буфера",
		},
	},
}
