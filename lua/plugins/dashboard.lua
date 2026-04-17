-- ~/.config/nvim/lua/plugins/dashboard.lua
return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- 🎨 Заголовок (ASCII-арт)
		dashboard.section.header.val = {
			"                                                     ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"                                                     ",
		}

		-- 🔘 Кнопки (интегрированы с твоим fzf и oil)
		dashboard.section.buttons.val = {
			dashboard.button("e", "📄  New File", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "🔍  Find Files", "<cmd>FzfLua files<CR>"),
			dashboard.button("r", "🕒  Recent", "<cmd>FzfLua oldfiles<CR>"),
			dashboard.button("b", "📚  Buffers", "<cmd>FzfLua buffers<CR>"),
			dashboard.button("o", "📂  Oil Filemanager", "<cmd>lua require('oil').open_float()<CR>"),
			dashboard.button("q", "🚪  Quit", "<cmd>qa<CR>"),
		}

		dashboard.section.footer.val = "Neovim 0.11 • Built with Lazy"
		dashboard.opts.layout[1].val = 8
		alpha.setup(dashboard.opts)

		-- 🛠 Убираем "No name" буфер при старте (если alpha не загрузился)
		vim.api.nvim_create_autocmd("BufEnter", {
			callback = function()
				if vim.bo.filetype == "" and vim.api.nvim_buf_get_name(0) == "" then
					local bufs = vim.api.nvim_list_bufs()
					if #bufs == 1 then
						vim.cmd("bd!")
					end
				end
			end,
		})
	end,
}
