-- ~/.config/nvim/lua/plugins/git.lua
return {
	-- 1️⃣ Gitsigns: Inline diff, hunk management, blame
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			watch_gitdir = { follow_files = true },
			attach_to_untracked = true,
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 800,
				ignore_whitespace = false,
			},
			preview_config = {
				border = "rounded",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		},
		keys = {
			{
				"<leader>gs",
				function()
					require("gitsigns").stage_hunk()
				end,
				desc = "Git: Stage Hunk",
			},
			{
				"<leader>gu",
				function()
					require("gitsigns").undo_stage_hunk()
				end,
				desc = "Git: Undo Stage",
			},
			{
				"<leader>gr",
				function()
					require("gitsigns").reset_hunk()
				end,
				desc = "Git: Reset Hunk",
			},
			{
				"<leader>gp",
				function()
					require("gitsigns").preview_hunk()
				end,
				desc = "Git: Preview Hunk",
			},
			{
				"<leader>gb",
				function()
					require("gitsigns").blame_line()
				end,
				desc = "Git: Blame Line",
			},
			-- ⚠️ Заменил gd → gv, чтобы не конфликтовать с LSP "Goto Definition"
			{
				"<leader>gv",
				function()
					require("gitsigns").diffthis()
				end,
				desc = "Git: Diff This File",
			},
			{
				"[h",
				function()
					require("gitsigns").nav_hunk("prev")
				end,
				desc = "Git: Prev Hunk",
			},
			{
				"]h",
				function()
					require("gitsigns").nav_hunk("next")
				end,
				desc = "Git: Next Hunk",
			},
		},
	},

	-- 2️⃣ Diffview: Полноценный diff-просмотрщик
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		keys = {
			{ "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Git: Open Diffview (current commit)" },
			{ "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git: File History" },
			{ "<leader>dl", "<cmd>DiffviewFileHistory --range=HEAD~20..<cr>", desc = "Git: Last 20 Commits" },
		},
		config = function()
			require("diffview").setup({
				enhanced_diff_hl = true,
				view = {
					default = { layout = "diff2_horizontal" },
					file_history = { layout = "diff2_horizontal" },
				},
				hooks = {
					diff_buf_win_enter = function(bufnr, winid)
						vim.opt_local.wrap = false
						vim.opt_local.number = true
						vim.opt_local.relativenumber = true
					end,
				},
			})
		end,
	},
}
