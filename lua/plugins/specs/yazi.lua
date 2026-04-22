-- plugins/specs/yazi.lua
return {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
        { "<leader>y", "<cmd>Yazi<CR>", desc = "Open Yazi" },
        { "<leader>Y", "<cmd>Yazi cwd<CR>", desc = "Yazi (cwd)" },
    },
    config = function()
        require("yazi").setup({
            open_for_directories = true,

            -- ✅ Размер окна (0.9 оставляет "воздух" по краям для размытого фона)
            floating_window_scaling_factor = 0.9,

            -- ✅ Рамка Neovim вокруг окна Yazi
            -- "rounded" - красивая скругленная рамка (рекомендую)
            -- "none"   - вообще без рамки
            -- "single" - тонкая линия
            yazi_floating_window_border = "rounded",

            -- ✅ Прозрачность самого окна Neovim (0 = полностью следует настройкам Kitty)
            yazi_floating_window_winblend = 0,

            yazi_floating_window_title = "Yazi",

            keymaps = {
                show_help = "<f1>",
                open_file_in_vertical_split = "<c-v>",
                open_file_in_horizontal_split = "<c-s>",
                open_file_in_tab = "<c-t>",
            },
        })
    end,
}
