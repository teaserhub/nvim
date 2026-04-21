-- ~/.config/nvim/lua/plugins/lsp.lua
-- ~/.config/nvim/lua/plugins/lsp.lua
return {
	-- 1️⃣ Mason: менеджер LSP-серверов и форматтеров
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				-- 🎯 Твой стек: языковые серверы
				"gopls",
				"clangd",
				"rust-analyzer",
				"lua-language-server",
				"eslint-lsp",
				"html-lsp",
				"css-lsp",
				"json-lsp",
				"bash-language-server",
				-- 🧹 Форматтеры
				"gofumpt",
				"goimports",
				"stylua",
				"prettier",
				"clang-format",
			},
		},
	},

	-- 2️⃣ Mason <-> LSP bridge (только для установки, настройку делаем вручную)
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				-- Не вызывать автоматический setup() для серверов — будем настраивать вручную через vim.lsp.config
				automatic_installation = true,
				handlers = {}, -- пустой, чтобы не конфликтовал с новым API
			})
		end,
	},

	-- 3️⃣ LSP конфигурация через НОВЫЙ API (Neovim 0.11+)
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- 🔹 Общие настройки для всех серверов
			local common_opts = {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- Локальные хоткеи только для буфера с LSP
					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
					end
					map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
					map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
					map("n", "gr", vim.lsp.buf.references, "Find References")
					map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
					map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Actions")
					map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
					map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
				end,
			}

			-- 🔹 Конфигурация серверов через новый API (vim.lsp.config)
			-- 🐹 Go
			vim.lsp.config(
				"gopls",
				vim.tbl_extend("force", common_opts, {
					settings = {
						gopls = {
							gofumpt = false,
							staticcheck = true,
							usePlaceholders = true,
							analyses = { unusedparams = true },
						},
					},
				})
			)

			-- 🦀 Rust
			vim.lsp.config(
				"rust_analyzer",
				vim.tbl_extend("force", common_opts, {
					settings = {
						["rust-analyzer"] = {
							check = { command = "clippy" },
							cargo = { allFeatures = true },
						},
					},
				})
			)

			-- 🐘 C / C++
			vim.lsp.config(
				"clangd",
				vim.tbl_extend("force", common_opts, {
					cmd = { "clangd", "--background-index", "--clang-tidy" },
				})
			)

			-- 🌙 Lua
			vim.lsp.config(
				"lua_ls",
				vim.tbl_extend("force", common_opts, {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim", "describe", "it", "before_each", "after_each" } },
							workspace = { library = vim.api.nvim_get_runtime_file("", true) },
							telemetry = { enable = false },
						},
					},
				})
			)

			-- 🌐 Web: JS/TS/HTML/CSS/JSON
			vim.lsp.config(
				"eslint",
				vim.tbl_extend("force", common_opts, {
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
				})
			)
			vim.lsp.config("html", common_opts)
			vim.lsp.config("cssls", common_opts)
			vim.lsp.config("jsonls", common_opts)
			vim.lsp.config("bashls", common_opts)

			-- 🔹 Глобальные хоткеи для форматирования (conform.nvim)
			vim.keymap.set("n", "<leader>fm", function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end, { desc = "Format File" })
		end,
	},

	-- 4️⃣ Автодополнение (cmp) — без изменений
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				}),
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
			})
		end,
	},

	-- 5️⃣ Форматирование (conform) — обновлённый стек
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				go = { "goimports", "gofumpt" },
				rust = { "rustfmt" },
				c = { "clang-format" },
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				["*"] = { "trim_whitespace", "trim_newlines" },
			},
			format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
		},
	},
}
