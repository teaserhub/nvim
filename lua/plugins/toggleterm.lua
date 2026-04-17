-- ~/.config/nvim/lua/plugins/terminal_session.lua
return {
	-- 1️⃣ ToggleTerm: гибкий терминал с плавающими и встроенными окнами
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Терминал: Переключить" },
			{
				"<leader>tf",
				"<cmd>ToggleTerm direction=float<cr>",
				desc = "Терминал: Плавающее окно",
			},
			{ "<leader>th", "<cmd>ToggleTerm direction=horizontal size=15<cr>", desc = "Терминал: Снизу" },
			{ "<leader>tv", "<cmd>ToggleTerm direction=vertical size=60<cr>", desc = "Терминал: Справа" },
			{ "<leader>ts", "<cmd>TermExec cmd='lazygit'<cr>", desc = "Git: Lazygit" },
		},
		config = function()
			require("toggleterm").setup({
				size = 15,
				open_mapping = [[<c-\>]], -- быстрый toggle из любого режима
				hide_numbers = true,
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "float",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "rounded",
					width = math.floor(vim.o.columns * 0.85),
					height = math.floor(vim.o.lines * 0.85),
					winblend = 3,
				},
			})
		end,
	},

	-- 2️⃣ Persisted: автосохранение и восстановление сессий
	{
		"olimorris/persisted.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- Расширяем список сохраняемых параметров сессии
			vim.opt.sessionoptions:append("globals") -- глобальные переменные (leader, опции)
			vim.opt.sessionoptions:append("winsize") -- размеры окон/сплитов
			vim.opt.sessionoptions:append("tabpages") -- табы

			require("persisted").setup({
				save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
				use_git_branch = true, -- отдельные сессии для каждой ветки
				autosave = true, -- автосохранение при выходе
				autoload = false, -- отключено, чтобы не ломать `nvim файл` из CLI
				silent = true,
				should_save = function()
					return not vim.tbl_contains({ "oil", "lazy", "fzf", "toggleterm", "Diffview" }, vim.bo.filetype)
				end,
			})

			-- Хоткеи управления сессиями
			vim.keymap.set("n", "<leader>Ss", "<cmd>PersistedSave<cr>", { desc = "Сессия: Сохранить" })
			vim.keymap.set("n", "<leader>Sl", "<cmd>PersistedLoad<cr>", { desc = "Сессия: Загрузить" })
			vim.keymap.set("n", "<leader>Sd", "<cmd>PersistedDelete<cr>", { desc = "Сессия: Удалить" })
			vim.keymap.set(
				"n",
				"<leader>St",
				"<cmd>PersistedToggle<cr>",
				{ desc = "Сессия: Авто-сохранение вкл/выкл" }
			)
		end,
	},
}
