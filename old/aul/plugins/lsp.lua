return {
    { "williamboman/mason.nvim", config = true },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },

        config = function()
            local lspconfig = require("lspconfig")
            local cmp_lsp = require("cmp_nvim_lsp")

            local capabilities = cmp_lsp.default_capabilities()

            local on_attach = function(_, bufnr)
                local opts = { buffer = bufnr }

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
            end

            require("mason-lspconfig").setup({
                ensure_installed = { "gopls" },
                handlers = {
                    function(server)
                        lspconfig[server].setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,

                    ["gopls"] = function()
                        lspconfig.gopls.setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = {
                                gopls = {
                                    staticcheck = true,
                                },
                            },
                        })
                    end,
                },
            })
        end,
    },
}
