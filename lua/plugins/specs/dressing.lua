return {
    {
        "stevearc/dressing.nvim",
        lazy = false,        -- загрузить сразу
        priority = 1000,     -- высокий приоритет (после темы)
        config = function()
            require("dressing").setup({
                input = {
                    enabled = true,
                    default_prompt = "➤ ",
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                        winblend = 0,
                    },
                    border = "rounded",
                },
                select = {
                    enabled = true,
                    backend = { "fzf_lua", "builtin" },
                    fzf_lua = {
                        fzf_opts = { ["--layout"] = "reverse-list" },
                    },
                    builtin = {
                        win_options = {
                            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                        },
                        border = "rounded",
                    },
                },
            })
        end,
    },
}
