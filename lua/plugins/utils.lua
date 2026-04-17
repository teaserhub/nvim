-- ~/.config/nvim/lua/plugins/utils.lua
return {
	-- 1️⃣ 📝 Авто-сохранение (умное, не трогает temp/readonly/терминалы)
	--{
	--	"Pocco81/auto-save.nvim",
	--	event = "VeryLazy",
	--	config = function()
	--		require("auto-save").setup({
	--			execution_message = false,
	--			trigger_events = { "InsertLeave", "TextChanged" },
	--			condition = function(buf)
	--				return vim.bo[buf].buftype == "" and vim.bo[buf].modifiable
	--			end,
	--		})
	--	end,
	--},

	-- 3️⃣ 💬 Умное комментирование (gcc, gc в визуальном режиме)
	{
		"echasnovski/mini.comment",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("mini.comment").setup()
		end,
	},

	-- 4️⃣ 🚀 Мгновенный поиск по тексту (замена f/F/t/T)
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		config = function()
			require("flash").setup()
		end,
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash Jump",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash AST",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "n", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Flash TS Search",
			},
		},
	},
}
