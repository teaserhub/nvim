return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        config = function()
            -- Кэшируем функции для производительности
            local lsp_client = function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then
                    return ""
                end
                local names = {}
                for _, c in ipairs(clients) do
                    if c.name ~= "copilot" then
                        table.insert(names, c.name)
                    end
                end
                return #names > 0 and ("󰒋 " .. table.concat(names, ",")) or ""
            end

            local macro_recording = function()
                local reg = vim.fn.reg_recording()
                return reg ~= "" and ("󰑋 @" .. reg) or ""
            end

            local diff_source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                    return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed,
                    }
                end
            end

            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "auto",  -- авто-тема (onedark)
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true,
                    refresh = { 
                        statusline = 100,  -- 100ms обновление
                        winbar = 1000,     -- реже для winbar
                    },
                },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                            fmt = function(str)
                                return str:sub(1, 1)  -- N/I/V/C
                            end,
                        },
                    },
                    lualine_b = {
                        { "branch", icon = "󰘬" },  -- ← иконка git
                        {
                            "diff",
                            source = diff_source,
                            symbols = { 
                                added = " ", 
                                modified = " ", 
                                removed = " " 
                            },
                            colored = true,
                        },
                    },
                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                            shorting_target = 50,
                            symbols = {
                                modified = " ●",
                                readonly = " ",
                                unnamed = "[No Name]",
                            },
                        },
                        -- Navic для Go (опционально)
                        -- {
                        --     "navic",
                        --     cond = function()
                        --         return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
                        --     end,
                        -- },
                    },
                    lualine_x = {
                        { macro_recording, color = { fg = "#ff9e64" } },
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },  -- ← новое имя для 0.11+
                            symbols = { 
                                error = " ", 
                                warn = " ", 
                                info = " ", 
                                hint = " " 
                            },
                            colored = true,
                            update_in_insert = false,
                        },
                        { lsp_client, color = { fg = "#7dcfff" } },
                        "filetype",
                    },
                    lualine_y = {
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        function()
                            return "󰥔 " .. os.date("%H:%M")  -- ← иконка часов
                        end,
                    },
                },
                inactive_sections = {
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "location" },
                },
                extensions = { 
                    "lazy", 
                    "mason", 
                    "trouble", 
                    "quickfix",
                    "fzf",      -- ← добавил fzf
                    "oil",      -- ← добавил oil
                },
            })
        end,
    },
}
