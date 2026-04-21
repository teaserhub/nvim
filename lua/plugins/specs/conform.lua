return {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    cmd = { "ConformInfo" },

    opts = {
        formatters_by_ft = {
            -- Go
            go = { "goimports", "gofumpt" },

            -- JS / TS
            javascript = { "prettier", stop_after_first = true },
            typescript = { "prettier", stop_after_first = true },
            javascriptreact = { "prettier", stop_after_first = true },
            typescriptreact = { "prettier", stop_after_first = true },

            -- Web
            html = { "prettier" },
            css = { "prettier" },
            scss = { "prettier" },

            -- Data
            json = { "prettier" },
            -- markdown = { "prettier" },

            -- Lua
            lua = { "stylua" },
        },

        format_on_save = {
            timeout_ms = 3000,
            lsp_fallback = "fallback",
            async = false,
        },

        default_format_opts = {
            lsp_format = "fallback",
        },

        formatters = {
            prettier = {
                prepend_args = { "--tab-width", "2", "--print-width", "100" },
            },
            stylua = {
                prepend_args = {
                    "--config-path",
                    vim.fn.stdpath("config") .. "/stylua.toml",
                },
            },
        },

        log_level = vim.log.levels.WARN, -- меньше шума
    },

    config = function(_, opts)
        require("conform").setup(opts)

        -- ручное форматирование
        vim.keymap.set({ "n", "v" }, "<leader>cf", function()
            require("conform").format({
                async = true,
                lsp_format = "fallback",
            })
        end, { desc = "Format code" })
    end,
}
