-- plugins/treesitter.lua
-- =============================================================
-- nvim-treesitter — продвинутая подсветка, отступы и folding (2026)
-- =============================================================

return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = "main",           -- важно после архивации репозитория в апреле 2026
        build = ":TSUpdate",        -- автоматически обновляет парсеры
        event = "BufReadPre",
        lazy = false,               -- Treesitter лучше грузить рано
        config = function()
            require("nvim-treesitter").setup({
                -- Какие языки устанавливать автоматически
                ensure_installed = {
                    "go", "gomod", "gowork", "gosum",
                    "lua", "luadoc",
                    "javascript", "typescript", "tsx",
                    "html", "css", "scss",
                    "json", "markdown", "markdown_inline",
                    "vim", "vimdoc", "query", -- для помощи по Neovim
                },

                -- Автоматически устанавливать парсеры для новых языков
                auto_install = true,

                -- Основные модули
                highlight = {
                    enable = true,                    -- продвинутая подсветка (лучше чем в VSCode)
                    additional_vim_regex_highlighting = false, -- отключаем старый regex (быстрее)
                },

                indent = {
                    enable = true,                    -- умные отступы
                },

                -- Incremental selection (выделение блоков кода)
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",   -- начать выделение
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },

                -- Folding (сворачивание кода) — как в VSCode
                fold = {
                    enable = true,
                },
            })

            -- Глобальные настройки folding на основе Treesitter (рекомендация 2026)
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldlevel = 99          -- по умолчанию всё раскрыто
            vim.wo.foldenable = true

            -- Автоматически включать Treesitter при открытии файла
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "*" },
                callback = function()
                    pcall(vim.treesitter.start)   -- безопасно запускаем
                end,
            })
        end,
    },
}
