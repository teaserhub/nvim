-- plugins/specs/flash.lua
return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        keys = {
            { "s", mode = { "n", "x", "o" }, desc = "Flash jump" },
            { "S", mode = { "n", "x", "o" }, desc = "Flash treesitter" },
        },
        opts = {
            -- Базовые настройки (всё включено по умолчанию)
            label = {
                rainbow = { enabled = true },
                uppercase = false,
            },
            highlight = {
                backdrop = true,
            },
            jump = {
                autojump = false,
            },
            modes = {
                search = { enabled = true },
                char = { enabled = true, multi_line = true },
                treesitter = { enabled = true },
                remote = { enabled = true },
            },
        },
        config = function(_, opts)
            local flash = require("flash")
            flash.setup(opts)
            
            -- 🎯 Клавиши (исправленные для 2026 API)
            
            -- s — прыжок по двум буквам
            vim.keymap.set({ "n", "x", "o" }, "s", function()
                flash.jump({
                    pattern = ".",  -- любая буква
                    search = { mode = "search" },
                })
            end, { desc = "Flash jump" })
            
            -- S — прыжок по treesitter
            vim.keymap.set({ "n", "x", "o" }, "S", function()
                flash.treesitter({
                    jump = { autojump = true },
                })
            end, { desc = "Flash treesitter" })
            
            -- f — вперёд по символу
            vim.keymap.set({ "n", "x", "o" }, "f", function()
                flash.jump({
                    search = { mode = "char", forward = true },
                })
            end, { desc = "Flash char forward" })
            
            -- F — назад по символу
            vim.keymap.set({ "n", "x", "o" }, "F", function()
                flash.jump({
                    search = { mode = "char", forward = false },
                })
            end, { desc = "Flash char backward" })
            
            -- t — перед символом вперёд
            vim.keymap.set({ "n", "x", "o" }, "t", function()
                flash.jump({
                    search = { mode = "char", forward = true, offset = -1 },
                })
            end, { desc = "Flash till forward" })
            
            -- T — после символа назад
            vim.keymap.set({ "n", "x", "o" }, "T", function()
                flash.jump({
                    search = { mode = "char", forward = false, offset = 1 },
                })
            end, { desc = "Flash till backward" })
            
            -- r — remote операции
            vim.keymap.set("o", "r", function()
                flash.remote()
            end, { desc = "Flash remote" })
            
            -- R — remote + treesitter
            vim.keymap.set({ "o", "x" }, "R", function()
                flash.treesitter_search()
            end, { desc = "Flash treesitter search" })
        end,
    },
}
