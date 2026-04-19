return {
	"neovim/nvim-lspconfig",
	config = function()
		-- включаем LSP
		vim.lsp.enable("gopls")
		vim.lsp.enable("lua_ls")

		-- настройки
		vim.lsp.config("gopls", {
			settings = {
				gopls = { gofumpt = true },
			},
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
				},
			},
		})

		-- бинды
		local group = vim.api.nvim_create_augroup("LspConfig", { clear = true })

		vim.api.nvim_create_autocmd("LspAttach", {
			group = group,
			callback = function(ev)
				local opts = { buffer = ev.buf }

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>f", function()
				-- 	vim.lsp.buf.format({ async = true })
				-- end, opts)
			end,
		})
	end,
}
