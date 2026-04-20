return {
        -- ══════════════════════════ CONFORM.NVIM (форматирование) ═══════════════════════
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },   -- грузим перед сохранением
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                go = { "goimports", "gofumpt" },           -- goimports сортирует imports, gofumpt — лучший gofmt
                javascript = { "prettier", stop_after_first = true },
                typescript = { "prettier", stop_after_first = true },
                javascriptreact = { "prettier", stop_after_first = true },
                typescriptreact = { "prettier", stop_after_first = true },
                html = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                json = { "prettier" },
                markdown = { "prettier" },
                -- lua = { "stylua" },   -- раскомментируй, если будешь много писать на Lua
            },

            -- Настройки форматирования на сохранение (как Save в VSCode)
            format_on_save = {
                timeout_ms = 2000,
                lsp_fallback = true,     -- если нет внешнего форматтера — используй LSP
                async = false,           -- синхронно (чтобы точно сохранилось отформатированным)
            },

            -- Дополнительные глобальные настройки
            default_format_opts = {
                lsp_format = "fallback",
            },
        },
    },
    }
