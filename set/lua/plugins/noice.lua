-- ~/.config/nvim/lua/plugins/noice.lua
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify", -- для красивых уведомлений
	},
	config = function()
		local noice = require("noice")

		-- 🔹 Перехватываем уведомления через noice
		vim.notify = require("notify")

		noice.setup({
			-- 🎨 Интеграция с темой (onedark)
			presets = {
				bottom_search = true, -- поиск внизу экрана
				command_palette = true, -- командная палитра как в VS Code
				long_message_to_split = true, -- длинные сообщения в сплите
				inc_rename = false, -- инкрементальное переименование (можно включить)
				lsp_doc_border = true, -- рамка вокруг документации LSP
			},

			-- 🔹 Маршрутизация сообщений
			routes = {
				-- Скрывать сообщения "X lines yanked" (они и так видны по подсветке)
				{
					filter = { event = "msg_show", kind = "", find = "lines yanked" },
					opts = { skip = true },
				},
				-- Скрывать уведомления от auto-save
				{
					filter = { event = "notify", find = "auto-save" },
					opts = { skip = true },
				},
			},

			-- 🔹 Настройка views (окон)
			views = {
				cmdline_popup = {
					position = { row = "50%", col = "50%" },
					size = { width = "60%", height = "auto" },
					border = { style = "rounded", padding = { 0, 1 } },
				},
				popupmenu = {
					relative = "editor",
					position = { row = 8, col = "50%" },
					size = { width = "60%", height = 10 },
					border = { style = "rounded", padding = { 0, 1 } },
				},
				hover = {
					border = { style = "rounded", padding = { 0, 1 } },
				},
				notify = {
					replace = true, -- использовать noice вместо nvim-notify
				},
			},

			-- 🔹 LSP интеграция
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				hover = { enabled = true },
				signature = { enabled = true, auto_open = { enabled = true, trigger = true } },
				message = { enabled = true },
				progress = { enabled = true },
			},

			-- 🔹 Command line
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
				format = {
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					search_down = { pattern = "^/", icon = " ", lang = "regex" },
					search_up = { pattern = "^%?", icon = " ", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
					lua = { pattern = "^:%s*lua%s+", icon = "", lang = "lua" },
					help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
					input = {},
				},
			},

			-- 🔹 Сообщения
			messages = {
				enabled = true,
				view = "notify",
				view_error = "notify",
				view_warn = "notify",
			},

			-- 🔹 Уведомления
			notify = {
				enabled = true,
				view = "notify",
			},

			-- 🔹 Прогресс-бары (LSP, Mason, Lazy)
			progress = {
				enabled = true,
				view = "mini",
			},
		})

		-- 🔹 Хоткеи для noice
		vim.keymap.set("n", "<leader>sn", function()
			noice.dismiss()
		end, { desc = "Noice: Скрыть все окна" })
		vim.keymap.set("n", "<leader>sh", function()
			noice.show("history")
		end, { desc = "Noice: История сообщений" })
		vim.keymap.set("n", "<leader>sl", function()
			noice.show("last")
		end, { desc = "Noice: Последнее сообщение" })
	end,
}
