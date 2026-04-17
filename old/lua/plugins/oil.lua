return {
    "stevearc/oil.nvim",

    cmd = "Oil",

    keys = {
        { "<leader>e", "<cmd>Oil<cr>", desc = "Open parent dir" },
    },

    opts = {
        default_file_explorer = true, -- заменяет netrw

        view_options = {
            show_hidden = false, -- быстрее
        },

        float = {
            padding = 2,
            max_width = 80,
            max_height = 30,
        },
    },
}
