-- ~/.config/nvim/lua/plugins/init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins.specs", {
    defaults = { lazy = true },

    -- 🔄 Авто-установка недостающих плагинов
    install = { missing = true },

    -- 🔄 Проверка обновлений (без назойливых уведомлений)
    checker = {
        enabled = true,
        notify = false,
        frequency = 86400, -- раз в сутки
    },

    -- 🔄 Авто-перезагрузка при изменении конфига
    change_detection = {
        enabled = true,
        notify = false,
    },

    -- 🎨 Красивый UI
    ui = {
        border = "rounded",
        backdrop = 100,
    },

    -- 🎯 Иконки (ASCII, работают без Nerd Font)
    icons = {
        cmd = "⌘",
        config = "🛠",
        event = "📅",
        ft = "📂",
        init = "⚙",
        keys = "🗝",
        plugin = "🔌",
        runtime = "💻",
        source = "📄",
        start = "🚀",
        task = "📌",
        lazy = "💤",
        loaded = "●",
        not_loaded = "○",
    },

    -- ⚡ Производительность
    performance = {
        cache = {
            enabled = true,
            path = vim.fn.stdpath("cache") .. "/lazy/cache",
        },
        reset_packpath = true, -- не сканировать стандартные пути (быстрее)
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },

    -- 🐛 Дебаг (только при проблемах)
    -- dev = {
    --     path = vim.fn.stdpath("data") .. "/lazydev",
    --     patterns = { "folke" },
    --     fallback = false,
    -- },

    -- 📊 Профилирование (опционально)
    profiling = {
        loader = false,
        require = false,
    },

    -- 📦 Поддержка luarocks (отключена, не нужно для Go)
    rocks = {
        enabled = false,
    },
})
