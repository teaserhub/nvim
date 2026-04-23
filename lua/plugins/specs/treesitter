-- plugins/treesitter.lua
-- =============================================================
-- nvim-treesitter (post-archive версия — апрель 2026)
-- =============================================================

return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,                    -- Treesitter должен грузиться рано
        build = ":TSUpdate",             -- обязательно!
        dependencies = {
            -- "nvim-treesitter/nvim-treesitter-textobjects",  -- пока закомментировали, чтобы не ломалось
        },
        config = function()
            require("nvim-treesitter").setup({
                ensure_installed = {
                    "go", "gomod", "gowork", "gosum",
                    "lua", "luadoc",
                    "javascript", "typescript", "tsx",
                    "html", "css", "scss",
                    "json", "markdown", "markdown_inline",
                    "vim", "vimdoc", "query",
                },

                auto_install = true,

                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },

                indent = {
                    enable = true,
                },

                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        node_decremental = "<bs>",
                    },
                },

                -- Text objects (временно упрощённо)
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                },
            })

            -- Folding на основе Treesitter
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldlevel = 99
            vim.wo.foldenable = true

            -- Автозапуск
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },
}
