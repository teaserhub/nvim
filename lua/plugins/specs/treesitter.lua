return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        -- dependencies = {
        --     "nvim-treesitter/nvim-treesitter-textobjects",  -- ← для vaf, vif и т.д.
        -- },
        config = function()
            require("nvim-treesitter").setup({
                ensure_installed = { 
                    "go", 
                    "gomod", 
                    "gowork", 
                },
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
            })

            -- Включаем Treesitter для Go
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "go" },
                callback = function()
                    vim.treesitter.start()
                    -- Включаем умное сворачивание
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.wo.foldmethod = "expr"
                end,
            })
        end,
    },

}
