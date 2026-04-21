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
                    -- "staticcheck",   -- статический анализ Go
                }
for _, tool in ipairs(tools) do
    local ok, pkg = pcall(registry.get_package, tool)
    if ok and not pkg:is_installed() then
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

            -- ▼ единственный блок sources (дубль удалён)
sources = {
    default = { "lsp", "path", "snippets", "buffer" },
providers = (function()
    local function not_in_string()
        local node = vim.treesitter.get_node({ ignore_injections = true })
        if not node then return true end
        local t = node:type()
        return t ~= "string"
            and t ~= "string_content"
            and t ~= "interpreted_string_literal"
            and t ~= "interpreted_string_literal_content"
            and t ~= "raw_string_literal"
            and t ~= "raw_string_literal_content"
            and t ~= "comment"
    end
    return {
        lsp      = { enabled = not_in_string },
        snippets = { enabled = not_in_string },
        buffer   = { enabled = not_in_string },
    }
end)(),
    
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
                    
                        -- 🔥 ВАЖНО: отключаем форматирование LSP
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
                    end

                    map("n", "gd", vim.lsp.buf.definition,  "Goto Definition")
                    map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
                    map("n", "K",  vim.lsp.buf.hover,       "Hover")
                    map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
map("n", "gr", vim.lsp.buf.references, "References")
map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                    map("n", "<leader>rn", vim.lsp.buf.rename,      "Rename")
                    map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
                    map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
                    map("n", "<leader>ih", function()
                        vim.lsp.inlay_hint.enable(
                            not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                        )
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
                            assignVariableTypes    = true,
                            compositeLiteralFields = true,
                            constantValues         = true,
                            parameterNames         = true,
                        },
                    },
                },
            })

            vim.lsp.config("ts_ls",  { single_file_support = true })
            vim.lsp.config("html",   {})
        vim.lsp.config("cssls",  {})
        vim.lsp.config("lua_ls",  {})

            vim.lsp.enable({ "gopls", "ts_ls", "html", "cssls", "lua_ls" })
        end,
    },
}
