return {
	-- 1️⃣ DAP (отладка)
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui", -- удобный интерфейс отладчика
		},
		config = function()
			require("dap-go").setup()
			require("dapui").setup({
				icons = { expanded = "▾", collapsed = "▸" },
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
						size = 10,
						position = "bottom",
					},
				},
				floating = { max_height = nil, max_width = nil, border = "rounded" },
			})
		end,
		keys = {
			{
				"<leader>dd",
				function()
					require("dap").continue()
				end,
				desc = "Go: Старт/Продолжить",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Go: Брекпоинт",
			},
			{
				"<leader>dn",
				function()
					require("dap").step_over()
				end,
				desc = "Go: Шаг дальше",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Go: Шаг внутрь",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Go: Шаг наружу",
			},
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Go: UI Отладчика",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Go: Остановить отладку",
			},
		},
	},

	-- 2️⃣ Быстрые команды Go (через уже настроенный toggleterm)
	{
		"akinsho/toggleterm.nvim",
		keys = {
			{ "<leader>gr", "<cmd>TermExec cmd='go run .'<cr>", desc = "Go: Запустить" },
			{ "<leader>gt", "<cmd>TermExec cmd='go test ./... -v'<cr>", desc = "Go: Тесты" },
			{
				"<leader>gb",
				"<cmd>TermExec cmd='go build -o ./bin/app'<cr>",
				desc = "Go: Собрать бинарник",
			},
			{ "<leader>gc", "<cmd>TermExec cmd='go clean -cache'<cr>", desc = "Go: Очистить кэш" },
		},
	},
}
