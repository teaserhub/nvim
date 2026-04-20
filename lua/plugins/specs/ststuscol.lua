return {
    {
        "luukvbaal/statuscol.nvim",
        event = "VeryLazy",
        dependencies = { "lewis6991/gitsigns.nvim" },
        config = function()
            local builtin = require("statuscol.builtin")
            
            require("statuscol").setup({
                setopt = true,
                relculright = true,
                segments = {
                    -- Git знаки (должны быть первыми!)
                    {
                        sign = { 
                            name = { "GitSigns.*" }, 
                            maxwidth = 1, 
                            colwidth = 1, 
                            auto = true 
                        },
                        click = "v:lua.Scfa",
                    },
                    -- Диагностика
                    {
                        sign = { 
                            name = { "Diagnostic.*" }, 
                            maxwidth = 1, 
                            colwidth = 1, 
                            auto = true 
                        },
                        click = "v:lua.Scfa",
                    },
                    -- Номера строк
                    {
                        text = { builtin.lnumfunc },
                        click = "v:lua.Scfa",
                    },
                    -- Фолды
                    {
                        text = { builtin.foldfunc },
                        click = "v:lua.Scfa",
                    },
                },
            })
            
            -- Ждём загрузки gitsigns и обновляем
            vim.defer_fn(function()
                pcall(vim.cmd, "redrawstatus")
            end, 200)
        end,
    },
}
