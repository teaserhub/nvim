-- ~/.config/nvim/lua/plugins/specs/theme.lua
return {
    -- 1️⃣ Иконки файлов
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    -- 2️⃣ OneDark Pro (активна по умолчанию)
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            require("onedark").setup({
                style = "dark",
                            -- 🔧 Тёмный фон как в GitHub Darki
                                        -- 🔧 Цвета VSCode Dark+
            colors = {
                -- Фон (как в VSCode)
                bg0 = "#1e1e1e",  -- основной фон
                bg1 = "#252526",  -- чуть светлее (статусбар)
                bg2 = "#2d2d30",  -- ещё светлее
                bg3 = "#3c3c3c",  -- границы

                -- Акценты VSCode
                red = "#f44747",      -- ошибки, return
                dark_red = "#d16969",
                green = "#6a9955",    -- строки, комментарии
                yellow = "#dcdcaa",   -- функции
                dark_yellow = "#d7ba7d",
                blue = "#9cdcfe",     -- типы
                purple = "#c586c0",   -- ключевые слова
                cyan = "#4ec9b0",     -- вызовы функций
                orange = "#ce9178",   -- числа, константы
            },
                transparent = false,
                terminal_colors = true,
                diagnostics = {
                    darker = true,
                    undercurl = true,
                    background = true,
                },
                highlight_groups = {
                    BufferLineFill = { bg = "#1e222a" },
                    BufferLineBufferSelected = { bg = "#282c34", fg = "#abb2bf", bold = true },
                    StatusLine = { bg = "#282c34", fg = "#abb2bf" },
                    CursorLine = { bg = "#2c313c" },
                    IncSearch = { bg = "#e5c07b", fg = "#282c34", bold = true },
                },
            })
            vim.cmd.colorscheme("onedark")
        end,
    },

--     {
--     "navarasu/onedark.nvim",
--     priority = 1000,
--     lazy = false,
--     config = function()
--         require("onedark").setup({
--             style = "darker",
--             transparent = false,
--             terminal_colors = true,
--             diagnostics = {
--                 darker = true,
--                 undercurl = true,
--                 background = true,
--             },
--             highlight_groups = {
--                 -- UI
--                 BufferLineFill = { bg = "#1e222a" },
--                 BufferLineBufferSelected = { bg = "#282c34", fg = "#abb2bf", bold = true },
--                 StatusLine = { bg = "#282c34", fg = "#abb2bf" },
--                 CursorLine = { bg = "#2c313c" },
--                 IncSearch = { bg = "#e5c07b", fg = "#282c34", bold = true },
--                 FloatBorder = { fg = "#5c6370" },
--                 NormalFloat = { bg = "#282c34" },
--                 Pmenu = { bg = "#21252b" },
--                 PmenuSel = { bg = "#3e4452" },
--
--                 -- ✅ Treesitter (правильные имена!)
--                 TSFunction = { fg = "#61afef", bold = true },
--                 TSMethod = { fg = "#61afef" },
--                 TSField = { fg = "#e5c07b" },
--                 TSParameter = { fg = "#e06c75" },
--                 TSType = { fg = "#e5c07b" },
--                 TSTypeBuiltin = { fg = "#e5c07b", italic = true },
--                 TSKeyword = { fg = "#c678dd", bold = true },
--                 TSString = { fg = "#98c379" },
--                 TSComment = { fg = "#5c6370", italic = true },
--                 TSTag = { fg = "#e06c75" },
--                 TSTagAttribute = { fg = "#98c379" },
--
--                 -- Git
--                 GitSignsAdd = { fg = "#98c379" },
--                 GitSignsChange = { fg = "#e5c07b" },
--                 GitSignsDelete = { fg = "#e06c75" },
--             },
--         })
--         vim.cmd.colorscheme("onedark")
--     end,
-- }

    -- 3️⃣ Catppuccin (закомментирована, раскомментируй чтобы использовать)
    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     priority = 1000,
    --     lazy = false,
    --     config = function()
    --         require("catppuccin").setup({
    --             flavour = "mocha", -- latte, frappe, macchiato, mocha
    --             background = { light = "latte", dark = "mocha" },
    --             transparent_background = false,
    --             term_colors = true,
    --             styles = {
    --                 comments = { "italic" },
    --                 functions = { "bold" },
    --                 keywords = { "italic" },
    --             },
    --             integrations = {
    --                 treesitter = true,
    --                 native_lsp = { enabled = true },
    --                 lsp_trouble = true,
    --                 lsp_saga = true,
    --                 gitgutter = false,
    --                 gitsigns = true,
    --                 telescope = true,
    --                 fzf = true,
    --                 which_key = true,
    --                 indent_blankline = { enabled = true },
    --                 dashboard = true,
    --                 neotree = true,
    --                 notify = true,
    --                 markdown = true,
    --                 neotest = true,
    --                 noice = true,
    --                 mini = true,
    --                 leap = true,
    --                 flash = true,
    --                 blink_cmp = true,
    --                 lualine = true,
    --                 navic = true,
    --                 oil = true,
    --                 snacks = true,
    --                 trouble = true,
    --                 yazi = true,
    --             },
    --             highlight_overrides = {
    --                 mocha = function(colors)
    --                     return {
    --                         CursorLine = { bg = colors.surface0 },
    --                         StatusLine = { bg = colors.mantle, fg = colors.text },
    --                     }
    --                 end,
    --             },
    --         })
    --         vim.cmd.colorscheme("catppuccin")
    --     end,
    -- },

    -- 4️⃣ GitHub Dark (закомментирована, раскомментируй чтобы использовать)
    -- {
    --     "projekt0n/github-nvim-theme",
    --     name = "github-theme",
    --     priority = 1000,
    --     lazy = false,
    --     config = function()
    --         require("github-theme").setup({
    --             theme_style = "dark_default",
    --             transparent = false,
    --             terminal_colors = true,
    --             overrides = {
    --                 CursorLine = { bg = "#21262d" },
    --                 StatusLine = { bg = "#161b22", fg = "#c9d1d9" },
    --             },
    --         })
    --         vim.cmd.colorscheme("github_dark")
    --     end,
    -- },
}
