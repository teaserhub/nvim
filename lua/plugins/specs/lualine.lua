-- plugins/specs/lualine.lua
return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "auto",                     -- подхватит цвета темы
                globalstatus = true,                -- единый статусбар
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = { "oil", "yazi", "Trouble" },
            },
            sections = {
                lualine_a = {
                    {
                        "mode",
                        fmt = function(str)
                            -- Короткие имена режимов
                            return str:sub(1, 1)
                        end,
                        separator = { left = "", right = "" },
                    },
                },
                lualine_b = {
                    {
                        "branch",
                        icon = "",
                        separator = "",
                    },
                    {
                        "diff",
                        symbols = {
                            added    = " ",
                            modified = " ",
                            removed  = " ",
                        },
                        separator = "",
                    },
                },
                lualine_c = {
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = {
                            error = " ",
                            warn  = " ",
                            info  = " ",
                            hint  = " ",
                        },
                        separator = "",
                    },
                },
                lualine_x = {
                    {
                        "filetype",
                        icon_only = false,
                        separator = "",
                    },
                    {
                        "encoding",
                        separator = "",
                        cond = function()
                            return vim.bo.fenc ~= "utf-8" and vim.bo.fenc ~= ""
                        end,
                    },
                    {
                        "fileformat",
                        symbols = {
                            unix    = "LF",
                            dos     = "CRLF",
                            mac     = "CR",
                        },
                        separator = "",
                    },
                },
                lualine_y = {
                    {
                        "filename",
                        path = 1,                     -- относительный путь
                        symbols = {
                            modified = " ●",
                            readonly = " ",
                            unnamed = "[No Name]",
                        },
                        separator = "",
                    },
                },
                lualine_z = {
                    {
                        "progress",
                        separator = "",
                    },
                    {
                        "location",
                        separator = " ",
                    },
                    {
                        function()
                            return os.date("%H:%M")
                        end,
                        separator = { left = "", right = "" },
                    },
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            extensions = { "fzf", "lazy", "mason", "trouble", "quickfix" },
        },
    },
}
