return {
    "neovim/nvim-lspconfig",
    event = "BufReadPre *.go",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        
        -- Go (gopls)
        vim.lsp.config("gopls", {
            cmd = { "gopls" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            root_markers = { "go.mod", ".git" },
            capabilities = capabilities,
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                        shadow = true,
                    },
                    staticcheck = true,
                },
            },
        })
        
        vim.lsp.enable("gopls")
        
        -- Клавиши LSP (один раз за сессию)
        vim.api.nvim_create_autocmd("LspAttach", {
            once = true,
            callback = function(args)
                local buf = args.buf
                
                -- K - hover с красивым попапом
                vim.keymap.set("n", "K", function()
                    vim.lsp.buf.hover({
                        border = "rounded",
                        max_width = 80,
                        max_height = 20,
                    })
                end, { buffer = buf, desc = "LSP Hover" })
                
                -- Навигация по коду
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Goto Definition" })
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buf, desc = "Goto Declaration" })
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buf, desc = "Goto Implementation" })
                vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buf, desc = "References" })
                
                -- Рефакторинг
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code Action" })
                
                -- Дополнительно (опционально)
                -- vim.keymap.set("n", "<leader>f", function()
                --     vim.lsp.buf.format({ async = true })
                -- end, { buffer = buf, desc = "Format" })
            end,
        })
    end,
}
