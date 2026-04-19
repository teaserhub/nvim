return {
    -- Mason (основной)
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
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
                -- ВСЁ ТУТ!
                ensure_installed = {
                    -- LSP
                    "gopls",
                    "lua_ls",
                    -- Форматтеры
                    "goimports",
                    "gofumpt",
                    "stylua",
                    -- Линтеры
                    "golangci-lint",
                    "luacheck",
                },
            })
        end,
    },

    -- Мост для lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        event = "BufReadPre",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                automatic_installation = true,
            })
        end,
    },
}
