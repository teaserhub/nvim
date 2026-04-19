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
        event = "InsertEnter",
        config = function()
            require("mini.pairs").setup({
                modes = { 
                    insert = true, 
                    command = true,
                    terminal = false,
                },
                -- Пропускать автопары в определённых контекстах
                skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
                skip_ts = { "string", "comment" },  -- пропускать в строках и комментариях
                skip_unbalanced = true,
                
                -- Дополнительные пары для Go
                mappings = {
                    ["`"] = { 
                        action = "open", 
                        pair = "``", 
                        neigh_pattern = "[^\\]`" 
                    },
                },
            })
        end,
    },
        --
        -- {
        -- "SmiteshP/nvim-navic",
        -- dependencies = { "neovim/nvim-lspconfig" },
        -- event = "LspAttach",
        -- opts = {
        --     highlight = true,
        --     separator = " > ",
        --     depth_limit = 5,
        --     lazy_update_context = true,
        -- },
    },
    

}
