return {
    "ibhagwan/fzf-lua",

    dependencies = {
        "nvim-tree/nvim-web-devicons", -- можно убрать если не нужны иконки
    },

    cmd = "FzfLua",

    keys = {
        { "<leader><leader>", "<cmd>FzfLua files<cr>",     desc = "Find files" },
        { "<leader>g",        "<cmd>FzfLua live_grep<cr>", desc = "Grep" },
        { "<leader>b",        "<cmd>FzfLua buffers<cr>",   desc = "Buffers" },
        { "<leader>r",        "<cmd>FzfLua oldfiles<cr>",  desc = "Recent files" },
    },

    opts = {
        winopts = {
            height = 0.85,
            width = 0.80,
            preview = {
                hidden = true, -- 🔥 ускоряет
            },
        },

        files = {
            git_icons = false,
        },

        grep = {
            rg_opts =
            "--hidden --column --line-number --no-heading --color=always --smart-case -g '!{.git,node_modules}'",
        },
    },
}
