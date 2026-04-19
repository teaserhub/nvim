-- ~/.config/nvim/lua/plugins/specs/session.lua
return {

	{
		"olimorris/persisted.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- 🔧 Настраиваем, что сохраняется в сессии
			pcall(function()
				vim.opt.sessionoptions:remove("terminal")
			end) -- терминалы часто ломают сессии
			vim.opt.sessionoptions:append("globals") -- глобальные переменные
			vim.opt.sessionoptions:append("localoptions") -- локальные опции окон (сплиты, скролл)
			vim.opt.sessionoptions:append("curdir") -- ✅ сохраняем рабочую директорию (критично!)
			vim.opt.sessionoptions:append("skiprtp") -- не сохраняем runtimepath (ускоряет загрузку)

			require("persisted").setup({
				save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
				use_git_branch = true, -- отдельные сессии для каждой ветки
				autosave = true, -- автосохранение при выходе
				autoload = true, -- ✅ автоматически грузит сессию при старте nvim
				follow_cwd = true, -- ✅ переключает сессию при :cd или открытии папки
				silent = true,
				-- Не сохраняем мусорные буферы и системные окна
				should_save = function()
					local ft = vim.bo.filetype
					return vim.fn.getcwd() ~= vim.env.HOME
						and ft ~= ""
						and not vim.tbl_contains(
							{ "oil", "lazy", "fzf", "toggleterm", "Diffview", "help", "dashboard" },
							ft
						)
				end,
			})

			-- 🔑 Хоткеи управления сессиями
			vim.keymap.set("n", "<leader>Ss", "<cmd>PersistedSave<cr>", { desc = "Сессия: Сохранить" })
			vim.keymap.set(
				"n",
				"<leader>Sl",
				"<cmd>PersistedLoad<cr>",
				{ desc = "Сессия: Загрузить/Выбрать" }
			)
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
