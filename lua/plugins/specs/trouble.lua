return {
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle focus=true<cr>", desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
            { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
            { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP (Trouble)" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
        },
        opts = {
            -- Настройки для Neovim 0.11+
            modes = {
                diagnostics = {
                    auto_open = false,
                    auto_close = false,
                    auto_preview = true,
                },
            },
            -- Красивый UI
            icons = {
                indent = {
                    top = "╰ ",
                    bottom = "╭ ",
                    fold_open = " ",
                    fold_closed = " ",
                },
                folder_closed = " ",
                folder_open = " ",
                kinds = vim.lsp.protocol.SymbolKind,  -- использовать иконки LSP
            },
            -- Окно
            win = {
                border = "rounded",
                position = "bottom",
                size = { height = 0.3 },  -- 30% высоты
            },
            -- Автообновление
            auto_refresh = true,
        },
    },
}
