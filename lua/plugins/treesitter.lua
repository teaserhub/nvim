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
}
