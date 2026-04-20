-- =============================================================
--  LSP · Mason · blink.cmp · nvim-lint  —  Neovim 0.11+ (2026)
-- =============================================================

return {

    -- ═══════════════════════════ MASON ═══════════════════════════
    {
        "williamboman/mason.nvim",
        cmd = "Mason", -- ✅ Грузится только по команде
        config = function()
            require("mason").setup({ ui = { border = "rounded" } })

            -- 📦 Автоустановка серверов при первом запуске (замена ensure_installed)
            vim.defer_fn(function()
                local servers = { "gopls", "ts_ls", "html", "cssls" }
                for _, server in ipairs(servers) do
                    local pkg = require("mason-registry").get_package(server)
                    if not pkg:is_installed() then
                        vim.notify("Installing " .. server .. "...", vim.log.levels.INFO)
                        pkg:install()
                    end
                end
            end, 500)
        end,
    },

    -- ═══════════════════════════ NVIM-LINT ═══════════════════════
    {
        "mfussenegger/nvim-lint",
        event = "VeryLazy", -- ✅ Конфиг только регистрирует autocmd, грузить на BufReadPre нет смысла
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                go         = { "golangcilint" }, -- ✅ Исправлено имя (было golangci_lint)
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
                callback = function()
                    pcall(lint.try_lint)
                end,
            })
        end,
    },

    -- ══════════════════════════ BLINK.CMP ════════════════════════

    -- ══════════════════════════ BLINK.CMP ════════════════════════
    {
        "saghen/blink.cmp",
        version = "1.*",
        event = "InsertEnter",
        dependencies = {
            "rafamadriz/friendly-snippets", -- ✅ Вернули коллекцию сниппетов (wr, main, forr, iferr и др.)
        },
        opts = {
            keymap = { preset = "super-tab" },
            appearance = { nerd_font_variant = "mono" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" }, -- ✅ Добавлен источник "snippets"
            },
            completion = {
                trigger = { show_on_trigger_character = true },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 300,
                    window = { border = "rounded" },
                },
                ghost_text = { enabled = false },
                list = { selection = { preselect = false, auto_insert = false } },
                menu = { border = "rounded" },
                accept = {
                    auto_brackets = { enabled = false },
                    create_undo_point = true,
                },
            },
            signature = { enabled = true, window = { border = "rounded" } },
            fuzzy = { implementation = "prefer_rust" },
        },
    },
    -- ════════════════════════════ LSP ════════════════════════════
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "saghen/blink.cmp" }, -- ✅ Только blink. Mason убран из зависимостей.
        config = function()
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
                float = { border = "rounded", source = true, header = "", prefix = "" },
            })

            -- ✅ Capabilities подтягиваются безопасно (lazy.nvim загрузит blink перед config)
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            vim.lsp.config("*", { capabilities = capabilities })

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
                    map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
                    map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")
                    map("n", "gr", vim.lsp.buf.references, "References")
                    map("n", "K", vim.lsp.buf.hover, "Hover")
                    map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                    map("v", "<leader>ca", vim.lsp.buf.code_action, "Code Action (visual)")
                    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
                    map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
                    map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
                    map("n", "<leader>d", vim.diagnostic.open_float, "Line Diagnostics")
                    map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostic List")

                    if client:supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                        map("n", "<leader>ih", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
                                { bufnr = bufnr })
                        end, "Toggle Inlay Hints")
                    end

                    if client:supports_method("textDocument/formatting") then
                        local fmt_group = vim.api.nvim_create_augroup("UserLspFormat_" .. bufnr, { clear = true })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = fmt_group,
                            buffer = bufnr,
                            callback = function() format_buf(bufnr) end,
                        })
                    end
                end,
            })

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
                        gofumpt = true,
                        staticcheck = true,
                        usePlaceholders = false,
                        analyses = { unusedparams = true, shadow = true },
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                        codelenses = { generate = true, gc_details = false },
                        directoryFilters = { "-.git", "-vendor", "-node_modules" },
                    },
                },
            })

            vim.lsp.config("ts_ls", {
                single_file_support = true,
                init_options = {
                    preferences = {
                        disableSuggestions = false,
                        includeCompletionsForModuleExports = true,
                    },
                },
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "literals",
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = false,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "literals",
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = false,
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
