-- plugins/specs/snacks.lua
return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            statuscolumn = {
                enabled = true,
                max_signs = 5,
                -- Показывать Git-знаки
                git = {
                    enabled = true,
                    signs = {
                        add = { text = "┃" },
                        change = { text = "┃" },
                        delete = { text = "_" },
                        topdelete = { text = "‾" },
                        changedelete = { text = "~" },
                    },
                },
                -- Показывать диагностику
                diagnostics = {
                    enabled = true,
                    signs = {
                        error = " ",
                        warn = " ",
                        hint = " ",
                        info = " ",
                    },
                },
                -- Фолды
                folds = {
                    enabled = true,
                    open = "",
                    closed = "",
                },
            },
        },
    },
}
