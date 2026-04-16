-- lua/plugins/qol.lua
return {
    -- 1. Красивая подсветка при копировании (Yank Highlight)
    {
        "machakann/vim-highlightedyank",
        config = function()
            vim.g.highlightedyank_highlight_duration = 300
            vim.g.highlightedyank_highlight_color = "#2d7a3d" -- зелёный, приятный
        end,
    },

    -- 2. Плавный курсор (очень красиво)
    -- {
    -- "sphamba/smear-cursor.nvim",
    -- config = function()
    -- require("smear-cursor").setup({
    -- smear_between_buffers = true,
    -- smear_between_windows = true,
    -- use_floating_windows = true,
    -- })
    -- end,
    -- },

    -- 3. Подсветка отступов (очень полезно)
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = { char = "│" },
                scope = { enabled = true, show_start = false, show_end = false },
            })
        end,
    },

    -- 4. Подсветка текущего блока кода
    {
        "shellRaining/hlchunk.nvim",
        config = function()
            require("hlchunk").setup({
                chunk = { enable = true, style = "#a6e3a1" },
                indent = { enable = false },
            })
        end,
    },

    -- 5. Автоматическое закрытие парных символов
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },
}
