-- plugins/specs/yazi.lua
return {
    {
        "mikavilpas/yazi.nvim",
        event = "VeryLazy",
        keys = {
            { "<leader>y", "<cmd>Yazi<CR>", desc = "Open Yazi" },
            { "<leader>Y", "<cmd>Yazi cwd<CR>", desc = "Yazi (cwd)" },
        },
        config = function()
            require("yazi").setup({
                open_for_directories = true,
                keymaps = {
                    show_help = "<f1>",
                    open_file_in_vertical_split = "<c-v>",
                    open_file_in_horizontal_split = "<c-s>",
                    open_file_in_tab = "<c-t>",
                },
                floating_window_scaling_factor = 0.9,
                yazi_floating_window_border = "rounded",
                yazi_floating_window_title = "Yazi",
            })
        end,
    },
}
