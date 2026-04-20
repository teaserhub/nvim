-- =============================================================
--  LSP · Mason · blink.cmp   —   Neovim 0.11+  (2026, 10/10)
-- =============================================================

return {

    -- ═══════════════════════════ MASON ═══════════════════════════
    {
        "williamboman/mason.nvim",
        cmd = "Mason", -- Грузить привызове
        config = function()
            require("mason").setup({
                ui = { border = "rounded" },
            })
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        event = "LspAttach",
        opts = {
            ensure_installed = { "gopls", "ts_ls", "html", "cssls" },
        },
    },

    -- ══════════════════════════ BLINK.CMP ════════════════════════
    {
        "saghen/blink.cmp",
        version = "1.*",
        event = "InsertEnter",
        dependencies = {
            -- "rafamadriz/friendly-snippets"
        },
        opts = {
            keymap = { preset = "super-tab" },
            appearance = {
                -- use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 300,
                    window = { border = "rounded" },
                },
                ghost_text = { enabled = false },
                list = {
                    selection = { preselect = false, auto_insert = false },
                },
                menu = { border = "rounded" },
            },
            signature = {
                enabled = true,
                window = { border = "rounded" },
            },
            fuzzy = { implementation = "prefer_rust" },
        },
    },

    -- ════════════════════════════ LSP ════════════════════════════
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "saghen/blink.cmp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            -- ── Диагностика ──────────────────────────────────────────
            vim.diagnostic.config({
                virtual_text = false,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚",
                        [vim.diagnostic.severity.WARN]  = "󰀪",
                        [vim.diagnostic.severity.HINT]  = "󰌶",
                        [vim.diagnostic.severity.INFO]  = "󰌵",
                    },
                },
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = true,
                    header = "",
                    prefix = "",
                },
            })

            -- ── Capabilities ─────────────────────────────────────────
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            vim.lsp.config("*", { capabilities = capabilities })

            -- ── Форматтеры ────────────────────────────────────────────
            local format_filter = {
                go         = "gopls",
                typescript = "ts_ls",
                javascript = "ts_ls",
                html       = "html",
                css        = "cssls",
                scss       = "cssls",
            }

            local function format_buf(bufnr)
                local ft = vim.bo[bufnr].filetype
                local formatter = format_filter[ft]
                vim.lsp.buf.format({
                    bufnr      = bufnr,
                    async      = false,
                    timeout_ms = 3000,
                    filter     = function(client)
                        return formatter == nil or client.name == formatter
                    end,
                })
            end

            -- ── LspAttach ─────────────────────────────────────────────
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
                    map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
                    map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")
                    map("n", "gr", vim.lsp.buf.references, "References")

                    -- Информация
                    map("n", "K", vim.lsp.buf.hover, "Hover")
                    map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

                    -- Действия
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                    map("v", "<leader>ca", vim.lsp.buf.code_action, "Code Action (visual)")
                    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")

                    -- Диагностика
                    map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
                    map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
                    map("n", "<leader>d", vim.diagnostic.open_float, "Line Diagnostics")
                    map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostic List")

                    -- Inlay hints: включаем только если сервер поддерживает
                    if client:supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

                        map("n", "<leader>ih", function()
                            vim.lsp.inlay_hint.enable(
                                not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
                                { bufnr = bufnr }
                            )
                        end, "Toggle Inlay Hints")
                    end

                    -- Автоформат при сохранении
                    if client:supports_method("textDocument/formatting") then
                        local fmt_group = vim.api.nvim_create_augroup(
                            "UserLspFormat_" .. bufnr, { clear = true }
                        )
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group    = fmt_group,
                            buffer   = bufnr,
                            callback = function() format_buf(bufnr) end,
                        })
                    end
                end,
            })

            -- ── LspDetach ─────────────────────────────────────────────
            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("UserLspDetach", { clear = true }),
                callback = function(args)
                    pcall(vim.api.nvim_del_augroup_by_name, "UserLspFormat_" .. args.buf)
                end,
            })

            -- ── Конфиги серверов ──────────────────────────────────────
            vim.lsp.config("gopls", {
                settings = {
                    gopls = {
                        gofumpt         = true,
                        staticcheck     = true,
                        usePlaceholders = false,
                        analyses        = {
                            unusedparams = true,
                            shadow       = true,
                        },
                        hints           = {
                            assignVariableTypes    = true,
                            compositeLiteralFields = true,
                            functionTypeParameters = true,
                            parameterNames         = true,
                            rangeVariableTypes     = true,
                        },
                        -- ✅ Оптимизации для больших проектов
                        codelenses = {
                            generate = true,
                            gc_details = false,
                        },

                    },
                },
            })

            vim.lsp.config("ts_ls", {
                single_file_support = true,
                init_options = {
                    preferences = {
                        disableSuggestions                 = false,
                        includeCompletionsForModuleExports = true,
                    },
                },
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints         = "literals",
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints          = false,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints         = "literals",
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints          = false,
                        },
                    },
                },
            })

            vim.lsp.config("html", {})
            vim.lsp.config("cssls", {})

            vim.lsp.enable({ "gopls", "ts_ls", "html", "cssls" })
        end,
    },
}
