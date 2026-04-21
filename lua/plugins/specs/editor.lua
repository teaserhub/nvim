-- plugins/specs/editor.lua
return {
    -- Отступы
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        main = "ibl",
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = {
                enabled = true,
                show_start = false,
                show_end = false,
            },
            exclude = {
                filetypes = {
                    "oil",
                    "terminal",
                    "help",
                    "lazy",
                    "mason",
                    "fzf",
                    "Trouble",
                    "dashboard",
                },
                buftypes = { "terminal", "nofile" },
            },
        },
    },

    -- Автопары
    {
        "echasnovski/mini.pairs",
        lazy = false,
        -- event = "InsertEnter",
        config = function()
            require("mini.pairs").setup({
                modes = { insert = true, command = true, terminal = false },
                skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
                skip_ts = { "string", "comment" },
                -- Добавить в setup(), если нужно отключать автопары в определённых типах файлов:
                skip_ft = { "gitcommit", "markdown", "help", "log" },
                skip_unbalanced = true,
                mappings = {
                    ["`"] = { action = "open", pair = "``", neigh_pattern = "[^\\]`" },
                },
            })
        end,
    },



}
