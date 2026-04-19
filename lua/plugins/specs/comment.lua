return {
    --  Умное комментирование (gcc, gc в визуальном режиме)
	{
		"echasnovski/mini.comment",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("mini.comment").setup()
		end,
	}, 
}
