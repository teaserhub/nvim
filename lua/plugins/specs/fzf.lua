return {
    "ibhagwan/fzf-lua",
    -- cmd = "FzfLua",  ← удалить эту строку
    keys = {
        { "<C-f>", "<cmd>FzfLua files<CR>", desc = "Find Files" },
        { "<C-g>", "<cmd>FzfLua live_grep<CR>", desc = "Live Grep" },
        { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find Files" },
        { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Live Grep" },
        { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
    },
    opts = {
        fzf_opts = { ["--layout"] = "reverse" },
    }
}
