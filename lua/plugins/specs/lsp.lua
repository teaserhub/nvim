-- plugins/lsp.lua
-- =============================================================
-- LSP + Mason + blink.cmp + nvim-lint — Neovim 0.11+/0.12 (2026)
-- =============================================================

return {
    -- MASON
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        opts = {
            ui = { border = "rounded" },
            max_concurrent_installers = 4,
        },
        config = function(_, opts)
            require("mason").setup(opts)

            vim.schedule(function()
                local registry = require("mason-registry")
                local tools = {
                    "gopls", "ts_ls", "html", "cssls",
                    "goimports", "gofumpt",
                    "prettier", "eslint_d",
                    "golangci-lint", "staticcheck",
                    -- "stylua",          -- раскомментируй позже
                }

                for _, tool in ipairs(tools) do
                    local pkg = registry.get_package(tool)
                    if pkg and not pkg:is_installed() then
                        vim.notify("Mason: installing " .. tool, vim.log.levels.INFO)
                        pkg:install()
                    end
                end
            end)
        end,
    },

    -- NVIM-LINT
    {
        "mfussenegger/nvim-lint",
        event = "VeryLazy",
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                go = { "golangci-lint" },
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
                callback = function()
                    if vim.bo.buflisted and vim.fn.line("$") <= 5000 then
                        pcall(lint.try_lint)
                    end
                end,
            })
        end,
    },

    -- BLINK.CMP
    {
        "saghen/blink.cmp",
        version = "1.*",
        event = "InsertEnter",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = {
            keymap = { preset = "super-tab" },
            appearance = {
                nerd_font_variant = "mono",
                use_nvim_cmp_as_default = true,
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            completion = {
                trigger = { show_on_trigger_character = true },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                    window = { border = "rounded" },
                },
                ghost_text = { enabled = false },
                list = { selection = { preselect = false, auto_insert = false } },
                menu = {
                    border = "rounded",
                    draw = {
                        columns = { { "kind_icon" }, { "label", gap = 1 }, { "kind" } },
                    },
                },
                accept = { auto_brackets = { enabled = false } },
            },
            signature = {
                enabled = true,
                window = { border = "rounded" },
            },
            fuzzy = { implementation = "prefer_rust" },
        },
    },

    -- LSP CONFIG
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "saghen/blink.cmp" },
        config = function()
            -- Diagnostics
            vim.diagnostic.config({
                virtual_text = { prefix = "●", spacing = 2 },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = { border = "rounded", source = true, header = "", prefix = "" },
            })

            local capabilities = require("blink.cmp").get_lsp_capabilities()
            vim.lsp.config("*", { capabilities = capabilities })

            -- Keymaps при подключении LSP
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end

                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
                    end

                    map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
                    map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
                    map("n", "K", vim.lsp.buf.hover, "Hover")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
                    map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
                    map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
                    map("n", "<leader>ih", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
                    end, "Toggle Inlay Hints")
                end,
            })

            -- Настройки серверов
            vim.lsp.config("gopls", {
                settings = {
                    gopls = {
                        gofumpt = true,
                        staticcheck = true,
                        analyses = { unusedparams = true, shadow = true, nilness = true },
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            constantValues = true,
                            parameterNames = true,
                        },
                    },
                },
            })

            vim.lsp.config("ts_ls", {
                single_file_support = true,
            })

            vim.lsp.config("html", {})
            vim.lsp.config("cssls", {})

            -- Запуск серверов
            vim.lsp.enable({ "gopls", "ts_ls", "html", "cssls" })
        end,
    },
}
