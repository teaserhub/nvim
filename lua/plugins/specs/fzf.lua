return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",  -- Явно указываем команду для ленивой загрузки
    keys = {
        { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find Files" },
        { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Live Grep" },
        { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
    },
    opts = {
        fzf_opts = { ["--layout"] = "reverse" },
    }
}
