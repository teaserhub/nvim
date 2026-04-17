vim.keymap.set("n", "<leader>e", "<Cmd>Explore<CR>")

vim.keymap.set("n", "<leader><leader>", function()
	require("fzf-lua").files()
end)

vim.keymap.set("n", "<leader>/", function()
	require("fzf-lua").live_grep()
end)

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
vim.keymap.set("n", "<Leader>fo", ":lua vim.lsp.buf.format()<CR>", opts)	
