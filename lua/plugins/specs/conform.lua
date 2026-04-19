return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = "",
                desc = "Format buffer",
            },
            {
                "<leader>F",
                function()
                    require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
                end,
                mode = { "n", "v" },
                desc = "Format injected lang",
            },
        },
        config = function()
            require("conform").setup({
                -- Форматтеры для твоих языков
                formatters_by_ft = {
                    go = { "goimports", "gofumpt" },  -- ← Go!
                    lua = { "stylua" },
                    python = { "isort", "black" },
                    rust = { "rustfmt", lsp_format = "fallback" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescriptreact = { "prettier" },
                    json = { "prettier" },
                    yaml = { "prettier" },
                    markdown = { "prettier" },
                },
                
                -- Глобальные настройки для Neovim 0.11+
                default_format_opts = {
                    lsp_format = "fallback",
                },
                
                -- Красивый UI
                notify_on_error = true,
                notify_no_formatters = false,
                
                -- Форматировать при сохранении
                format_on_save = function(bufnr)
                    -- Отключить для больших файлов
                    if vim.api.nvim_buf_line_count(bufnr) > 5000 then
                        return false
                    end
                    return { timeout_ms = 2000, lsp_format = "fallback" }
                end,
                
                -- Автоустановка форматтеров через Mason
                formatters = {
                    goimports = {
                        prepend_args = { "-local", "github.com" },  -- группировать локальные импорты
                    },
                    stylua = {
                        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
                    },
                },
            })
            
            -- Клавиша для ручного форматирования (уже есть в keymaps)
            -- vim.keymap.set("n", "<leader>f", function()
            --     require("conform").format({ async = true })
            -- end, { desc = "Format" })
        end,
    },
}
