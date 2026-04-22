-- lua/plugins/zenmode.lua
return {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",  -- 👈 Загружать плагин только при вызове команды
    keys = {
        { "<leader>z", "<cmd>ZenMode<CR>", desc = "Zen Mode" },
    },
    config = function()
        require("zen-mode").setup({
            window = {
                width = 0.85, -- 85% ширины экрана
                options = {
                    number = false,
                    relativenumber = false,
                    cursorline = false,
                    signcolumn = "no",  -- 👈 Добавьте это для полной чистоты
                    list = false,       -- 👈 Убирает невидимые символы
                },
            },
            -- Дополнительные полезные настройки
            plugins = {
                -- Отключаем лишние элементы интерфейса
                options = {
                    laststatus = 0,     -- Скрыть статус-линию
                    showtabline = 0,    -- Скрыть табы
                },
                gitsigns = { enabled = false },  -- Скрыть гит-значки
                twilight = { enabled = false },  -- Если установлен twilight
            },
            -- Затемнение фона
            backdrop = 0.95,  -- 0.95 = почти прозрачный, 1 = полное затемнение
        })

        -- Ключ маппинг дублируется в keys, но можно оставить и здесь
        -- vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { desc = "Zen Mode" })
    end,
}
