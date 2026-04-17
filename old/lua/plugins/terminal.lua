return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            direction = "float", -- 🔥 как VSCode popup
            open_mapping = [[<C-\>]], -- Ctrl + \  — открыть/закрыть терминал
            shade_terminals = true,
            start_in_insert = true,
            persist_size = true,
            close_on_exit = true,
            insert_mappings = true,
            float_opts = {
                border = "rounded",
                width = function()
                    return math.floor(vim.o.columns * 0.85)
                end,
                height = function()
                    return math.floor(vim.o.lines * 0.75)
                end,
            },
        })
    end,
}
