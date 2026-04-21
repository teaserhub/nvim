-- plugins/lsp.lua
-- =============================================================
-- LSP + Mason + blink.cmp + nvim-lint — Neovim 0.12 (2026)
-- =============================================================

return {
    -- ====================== MASON ======================
    -- Устанавливает и управляет LSP-серверами и инструментами
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        opts = {
            ui = { border = "rounded" },
            max_concurrent_installers = 4,
        },
        config = function(_, opts)
            require("mason").setup(opts)

            -- Автоматическая установка нужных инструментов при первом запуске
            vim.schedule(function()
                local registry = require("mason-registry")
                local tools = {
                    "gopls",         -- Go LSP
                    "ts_ls",         -- TypeScript/JavaScript LSP
                    "html",          -- HTML LSP
                    "cssls",         -- CSS LSP
                    "goimports",     -- сортировка импортов в Go
                    "gofumpt",       -- строгий форматтер Go
                    "prettier",      -- основной форматтер для JS/TS/HTML/CSS
                    "eslint_d",      -- быстрый линтер JS/TS
                    "golangci-lint", -- продвинутый линтер Go
                    "staticcheck",   -- статический анализ Go
                    -- "stylua",      -- раскомментируй, если будешь много писать на Lua
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

    -- ====================== NVIM-LINT ======================
    -- Линтеры (показывает ошибки и предупреждения)
    {
        "mfussenegger/nvim-lint",
        event = "VeryLazy",
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                go = { "golangci-lint" }, -- ← исправлено (без дефиса!)
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
            }

            -- Запускаем линтеры после сохранения и выхода из режима вставки
            vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
                callback = function()
                    -- Защита от очень больших файлов
                    if vim.bo.buflisted and vim.fn.line("$") <= 5000 then
                        pcall(lint.try_lint)
                    end
                end,
            })
        end,
    },

    -- ====================== BLINK.CMP ======================
    -- Автодополнение (самый быстрый в 2026 году)
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

            fuzzy = { implementation = "prefer_rust" }, -- самый быстрый режим
        },
    },

    -- ====================== LSP CONFIG ======================
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "saghen/blink.cmp" },
        config = function()
            -- ==================== Diagnostics ====================
            vim.diagnostic.config({
                virtual_text = { prefix = "●", spacing = 2 },
                underline = true,
                    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚",
            [vim.diagnostic.severity.WARN]  = "󰀪",
            [vim.diagnostic.severity.INFO]  = "󰌵",
            [vim.diagnostic.severity.HINT]  = "󰌶",
        },
    },
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = true,
                    header = "",
                    prefix = "",
                },
            })

            -- Capabilities от blink.cmp
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            vim.lsp.config("*", { capabilities = capabilities })

            -- ==================== Filetype fixes ====================
            -- Убираем предупреждения "Unknown filetype 'gowork'" и "gotmpl"
            vim.filetype.add({
                extension = {
                    gowork = "gowork",
                    gotmpl = "gotmpl",
                },
            })

            -- ==================== Keymaps ====================
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end

                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
                    end

                    -- Навигация
                    map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
                    map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
                    map("n", "K", vim.lsp.buf.hover, "Hover")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")

                    -- Диагностика
                    map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
                    map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
                    map("n", "<leader>ih", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
                    end, "Toggle Inlay Hints")
                end,
            })

            -- ==================== Серверы ====================
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

            -- Запуск всех серверов
            vim.lsp.enable({ "gopls", "ts_ls", "html", "cssls" })
        end,
    },
}
