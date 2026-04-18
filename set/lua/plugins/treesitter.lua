return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		version = "*", -- 🔥 фиксируем стабильную версию
		lazy = false,

		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},

		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"go",
					"gomod",
					"lua",
					"bash",
					"json",
					"yaml",
					"toml",
				},

				highlight = {
					enable = true,
				},

				indent = {
					enable = true,
				},

				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-Space>",
						node_incremental = "<C-Space>",
						node_decremental = "<BS>",
					},
				},

				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
						},
					},

					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
						},
					},
				},
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
