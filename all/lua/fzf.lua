return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			winopts = { backdrop = 85 },
		})

		-- keymaps
		vim.keymap.set("n", "<leader><leader>", fzf.files)
		vim.keymap.set("n", "<leader>/", fzf.live_grep)
	end,
}
