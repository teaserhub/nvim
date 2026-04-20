-- =============================================================
-- LSP · Mason · blink.cmp · nvim-lint — Neovim 0.11+/0.12 (2026)
-- =============================================================
return {
    -- ═══════════════════════════ MASON ═══════════════════════════
    {
        "mason-org/mason.nvim",          -- ← официальный репозиторий 2026
        cmd = "Mason",
        opts = {
            ui = { border = "rounded" },
            max_concurrent_installers = 4,   -- официальная рекомендация
        },
        config = function(_, opts)
            require("mason").setup(opts)

            -- Автоустановка при первом запуске (vim.schedule — современнее defer_fn)
            vim.schedule(function()
                local registry = require("mason-registry")
                local servers = { "gopls", "ts_ls", "html", "cssls" }

                for _, server in ipairs(servers) do
                    local pkg = registry.get_package(server)
                    if pkg and not pkg:is_installed() then
                        vim.notify("Mason: installing " .. server, vim.log.levels.INFO)
                        pkg:install():on("close", function()
                            if pkg:is_installed() then
                                vim.notify(server .. " installed ✓", vim.log.levels.INFO)
                            end
                        end)
                    end
                end
            end)
        end,
    },

    -- ═══════════════════════════ NVIM-LINT ═══════════════════════
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

            -- Официальная рекомендация 2026: только BufWritePost + InsertLeave
            vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
                callback = function()
                    -- Защита от больших файлов
                    if vim.bo.buflisted and vim.fn.line("$") <= 5000 then
                        pcall(lint.try_lint)
                    end
                end,
            })
        end,
    },

    -- ══════════════════════════ BLINK.CMP ════════════════════════
    {
        "saghen/blink.cmp",
        version = "1.*",
        event = "InsertEnter",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        opts = {
            keymap = { preset = "super-tab" },

            appearance = {
                nerd_font_variant = "mono",
                use_nvim_cmp_as_default = true,   -- ← важно для тем 2026
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

                list = {
                    selection = { preselect = false, auto_insert = false },
                },

                menu = {
                    border = "rounded",
                    -- Современный draw (официальная документация 2026)
                    draw = {
                        columns = {
                            { "kind_icon" },
                            { "label", gap = 1 },
                            { "kind" },
                        },
                    },
                },

                accept = {
                    auto_brackets = { enabled = false },
                    create_undo_point = true,
                },
            },

            signature = {
                enabled = true,
                window = { border = "rounded" },
            },

            fuzzy = { implementation = "prefer_rust" }, -- самый быстрый вариант
        },
    },

    -- ════════════════════════════ LSP ════════════════════════════
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "saghen/blink.cmp" },
        config = function()
            -- Diagnostics (современно и красиво)
            vim.diagnostic.config({
                virtual_text = { prefix = "●", spacing = 2 },
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

            local capabilities = require("blink.cmp").get_lsp_capabilities()
            vim.lsp.config("*", { capabilities = capabilities })

            -- Форматирование только от нужного клиента
            local format_filter = {
                go = "gopls",
                typescript = "ts_ls",
                javascript = "ts_ls",
                html = "html",
                css = "cssls",
                scss = "cssls",
            }

            local function format_buf(bufnr)
                local ft = vim.bo[bufnr].filetype
                local allowed = format_filter[ft]

                vim.lsp.buf.format({
                    bufnr = bufnr,
                    async = false,
                    timeout_ms = 4000,
                    filter = function(client)
                        return not allowed or client.name == allowed
                    end,
                })
            end

            -- LspAttach (официальный современный способ)
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end

                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
                    end

                    -- Основные маппинги
                    map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
                    map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
                    map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
                    map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")
                    map("n", "gr", vim.lsp.buf.references, "References")
                    map("n", "K", vim.lsp.buf.hover, "Hover")
                    map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

                    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                    map("v", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")

                    map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
                    map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
                    map("n", "<leader>d", vim.diagnostic.open_float, "Line Diagnostics")
                    map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostic List")

                    -- Inlay hints (нативно с 0.10+)
                    if client:supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                        map("n", "<leader>ih", function()
                            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                            vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
                        end, "Toggle Inlay Hints")
                    end

                    -- Форматирование на BufWritePre
                    if client:supports_method("textDocument/formatting") then
                        local group = vim.api.nvim_create_augroup("UserLspFormat_" .. bufnr, { clear = true })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = group,
                            buffer = bufnr,
                            callback = function() format_buf(bufnr) end,
                        })
                    end
                end,
            })

            -- Cleanup
            vim.api.nvim_create_autocmd("LspDetach", {
                callback = function(args)
                    pcall(vim.api.nvim_del_augroup_by_name, "UserLspFormat_" .. args.buf)
                end,
            })

            -- ==================== Серверы ====================
            vim.lsp.config("gopls", {
                settings = {
                    gopls = {
                        gofumpt = true,
                        staticcheck = true,
                        usePlaceholders = false,
                        analyses = { unusedparams = true, shadow = true, nilness = true },
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                        codelenses = { generate = true, gc_details = false, test = true },
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

            vim.lsp.config("html", { filetypes = { "html", "templ" } })
            vim.lsp.config("cssls", {})

            vim.lsp.enable({ "gopls", "ts_ls", "html", "cssls" })
        end,
    },
}
