-- plugins/conform.lua
-- =============================================================
-- Conform.nvim — умное форматирование (аналог Prettier + gofmt в VSCode)
-- =============================================================

return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
        formatters_by_ft = {
            go = { "goimports", "gofumpt" },
            javascript = { "prettier", stop_after_first = true },
            typescript = { "prettier", stop_after_first = true },
            javascriptreact = { "prettier", stop_after_first = true },
            typescriptreact = { "prettier", stop_after_first = true },
            html = { "prettier" },
            css = { "prettier" },
            scss = { "prettier" },
            json = { "prettier" },
            markdown = { "prettier" },
            lua = { "stylua" },          -- раскомментируй после установки stylua
        },

        format_on_save = {
            timeout_ms = 2000,
            lsp_fallback = true,      -- если нет внешнего форматтера — использует LSP
            async = false,
        },

        default_format_opts = {
            lsp_format = "fallback",
        },
    },
}
