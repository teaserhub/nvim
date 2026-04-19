return {
    -- Mason (установщик LSP)
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",  -- обновить реестр при установке
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },

    -- Мост между Mason и lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        event = "BufReadPre *.go",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "gopls" },  -- автоустановка gopls
                automatic_installation = true,   -- ставить само если нет
            })
        end,
    },
}
