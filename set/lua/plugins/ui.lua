-- ~/.config/nvim/lua/plugins/ui.lua
return {
	-- -- 1️⃣ Bufferline
	-- {
	-- 	"akinsho/bufferline.nvim",
	-- 	version = "*",
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 	-- Загружаем на раннем этапе, но не блокируя старт
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("bufferline").setup({
	-- 			options = {
	-- 				mode = "buffers",
	-- 				separator_style = "none",
	-- 				show_buffer_close_icons = true,
	-- 				show_buffer_icons = false,
	-- 				diagnostics = "nvim_lsp",
	-- 				always_show_bufferline = true,
	-- 				offsets = {
	-- 					{ filetype = "oil", text = "Oil", highlight = "Directory", text_align = "left" },
	-- 				},
	-- 			},
	-- 		})
	-- 		-- 🛠 Форсируем отрисовку bufferline сразу после загрузки интерфейса
	-- 		vim.api.nvim_create_autocmd("UIEnter", {
	-- 			once = true,
	-- 			callback = function()
	-- 				vim.cmd("redrawstatus")
	-- 			end,
	-- 		})
	-- 	end,
	-- 	keys = {
	-- 		{ "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Следующий буфер" },
	-- 		{ "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Предыдущий буфер" },
	-- 		{ "<leader>bc", "<cmd>bdelete<cr>", desc = "Закрыть текущий буфер" },
	-- 		{ "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Закрыть остальные" },
	-- 		{ "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Следующий буфер (Tab)", mode = "n" },
	-- 		{
	-- 			"<S-Tab>",
	-- 			"<cmd>BufferLineCyclePrev<cr>",
	-- 			desc = "Предыдущий буфер (Shift+Tab)",
	-- 			mode = "n",
	-- 		},
	-- 	},
	-- },

	-- Lualine

	-- 	{
	-- 		"nvim-lualine/lualine.nvim",
	-- 		dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 		event = "VeryLazy",
	-- 		config = function()
	-- 			require("lualine").setup({
	-- 				options = {
	-- 					icons_enabled = true,
	-- 					theme = "auto",
	-- 					component_separators = { left = "", right = "" },
	-- 					section_separators = { left = "", right = "" },
	-- 					globalstatus = true,
	--
	-- 					padding = 1,
	-- 				},
	-- 				sections = {
	-- 					lualine_a = { "mode" },
	-- 					lualine_b = { "branch", "diff", "diagnostics" },
	-- 					lualine_c = { { "filename", path = 1 } },
	-- 					lualine_x = { "encoding", "fileformat", "filetype" },
	-- 					lualine_y = { "progress" },
	-- 					lualine_z = { "location" },
	-- 				},
	-- 			})
	-- 		end,
	-- 	},
	--
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			local function lsp_client()
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if #clients == 0 then
					return ""
				end
				local names = {}
				for _, c in ipairs(clients) do
					if c.name ~= "null-ls" and c.name ~= "copilot" then
						table.insert(names, c.name)
					end
				end
				return #names > 0 and ("󰒋 " .. table.concat(names, ",")) or ""
			end

			local function macro_recording()
				local reg = vim.fn.reg_recording()
				return reg ~= "" and ("󰑋 @" .. reg) or ""
			end

			local function diff_source()
				local gitsigns = vim.b.gitsigns_status_dict
				if gitsigns then
					return {
						added = gitsigns.added,
						modified = gitsigns.changed,
						removed = gitsigns.removed,
					}
				end
			end

			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					-- Острые стрелки — сразу видно секции
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					globalstatus = true,
					refresh = { statusline = 100 }, -- быстрее обновление
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(str)
								return str:sub(1, 1)
							end, -- N/I/V/C — коротко
						},
					},
					lualine_b = {
						{ "branch", icon = "" },
						{
							"diff",
							source = diff_source, -- через gitsigns, точнее
							symbols = { added = " ", modified = " ", removed = " " },
							colored = true,
						},
					},
					lualine_c = {
						{
							"filename",
							path = 1, -- относительный путь
							shorting_target = 50,
							symbols = {
								modified = " ●", -- видно что файл грязный
								readonly = " ",
								unnamed = "[No Name]",
							},
						},
						-- показывает текущую функцию/класс (нужен nvim-treesitter)
						-- { "navic", cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end },
					},
					lualine_x = {
						-- macro recording — критично не пропустить
						{ macro_recording, color = { fg = "#ff9e64" } },
						{
							"diagnostics",
							sources = { "nvim_lsp" },
							symbols = { error = " ", warn = " ", info = " ", hint = "󰠠 " },
							colored = true,
							update_in_insert = false,
						},
						{ lsp_client, color = { fg = "#7dcfff" } },
						"filetype",
					},
					lualine_y = {
						{ "progress", separator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
					},
					lualine_z = {
						-- реальное время — понимаешь когда 3 часа ночи
						function()
							return " " .. os.date("%H:%M")
						end,
					},
				},
				inactive_sections = {
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "location" },
				},
				extensions = { "neo-tree", "lazy", "mason", "trouble", "quickfix" },
			})
		end,
	},
}
