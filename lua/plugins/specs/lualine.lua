return {
    -- mini.icons + mini.statusline вместе (рекомендуемый подход)
    {
        "nvim-mini/mini.nvim", -- можно установить весь пакет сразу (удобнее)
        version = false,
        config = function()
            -- ====================== MINI.ICONS ======================
            local icons = require("mini.icons")
            icons.setup({
                style = "glyph", -- или "ascii", если нет Nerd Font

                -- Примеры кастомизации (по желанию)
                filetype = {
                    [""] = { glyph = "", hl = "MiniIconsGrey" }, -- пустой буфер
                },

                lsp = {
                    supermaven = { glyph = "󰚩", hl = "MiniIconsPurple" },
                },
            })

            -- Обязательно для совместимости со старыми плагинами
            icons.mock_nvim_web_devicons()

            -- ====================== MINI.STATUSLINE ======================
            local sl = require("mini.statusline")

            -- Иконки для диагностики и LSP
            local diag_icons = {
                ERROR = icons.get("diagnostic", "ERROR") or "󰅚",
                WARN  = icons.get("diagnostic", "WARN") or "󰀪",
                INFO  = icons.get("diagnostic", "INFO") or "󰌵",
                HINT  = icons.get("diagnostic", "HINT") or "󰌶",
            }

            local lsp_icon = icons.get("lsp", "server") or "󰒓"

            -- Кэш диагностики
            local diag_cache = ""
            vim.api.nvim_create_autocmd("DiagnosticChanged", {
                callback = function(args)
                    if args.buf ~= vim.api.nvim_get_current_buf() then return end

                    local counts = vim.diagnostic.count(0)
                    local parts = {}

                    if counts[vim.diagnostic.severity.ERROR] then
                        table.insert(parts, diag_icons.ERROR .. counts[vim.diagnostic.severity.ERROR])
                    end
                    if counts[vim.diagnostic.severity.WARN] then
                        table.insert(parts, diag_icons.WARN .. counts[vim.diagnostic.severity.WARN])
                    end
                    if counts[vim.diagnostic.severity.INFO] then
                        table.insert(parts, diag_icons.INFO .. counts[vim.diagnostic.severity.INFO])
                    end
                    if counts[vim.diagnostic.severity.HINT] then
                        table.insert(parts, diag_icons.HINT .. counts[vim.diagnostic.severity.HINT])
                    end

                    diag_cache = #parts > 0 and table.concat(parts, " ") or ""
                end,
            })

            -- Кэш LSP
            local lsp_cache = ""
            local function update_lsp_cache()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then
                    lsp_cache = ""
                    return
                end

                local names = vim.tbl_map(function(c) return c.name end, clients)
                names = vim.fn.uniq(names) -- убираем дубли
                lsp_cache = lsp_icon .. " " .. table.concat(names, ",")
            end

            vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "BufEnter" }, {
                callback = function(args)
                    if args.buf == vim.api.nvim_get_current_buf() then
                        update_lsp_cache()
                    end
                end,
            })

            -- ====================== SETUP STATUSLINE ======================
            sl.setup({
                content = {
                    active = function()
                        local mode, mode_hl = sl.section_mode({ trunc_width = 75 })
                        local git = sl.section_git({ trunc_width = 75 })
                        local filename = sl.section_filename({ trunc_width = 120 })
                        local location = sl.section_location({ trunc_width = 90 })

                        return sl.combine_groups({
                            { hl = mode_hl,                 strings = { mode } },
                            { hl = "MiniStatuslineDevinfo", strings = { git } },
                            { hl = "MiniStatuslineDevinfo", strings = { diag_cache } },
                            { hl = "MiniStatuslineDevinfo", strings = { lsp_cache } },

                            "%<",
                            { hl = "MiniStatuslineFilename", strings = { filename } },
                            "%=",

                            { hl = "MiniStatuslineFileinfo", strings = { vim.bo.filetype:upper() } },
                            { hl = mode_hl,                  strings = { location } },
                        })
                    end,

                    inactive = function()
                        return sl.combine_groups({
                            { hl = "MiniStatuslineFilename", strings = { "%f %m%r" } },
                        })
                    end,
                },

                use_icons = true,
                set_vim_settings = true,
            })
        end,
    },
    -- {
    --     "nvim-lualine/lualine.nvim",
    --     dependencies = { "nvim-tree/nvim-web-devicons" },
    --     event = "VeryLazy",
    --     config = function()
    --         -- Кэшируем функции для производительности
    --         local lsp_client = function()
    --             local clients = vim.lsp.get_clients({ bufnr = 0 })
    --             if #clients == 0 then
    --                 return ""
    --             end
    --             local names = {}
    --             for _, c in ipairs(clients) do
    --                 if c.name ~= "copilot" then
    --                     table.insert(names, c.name)
    --                 end
    --             end
    --             return #names > 0 and ("󰒋 " .. table.concat(names, ",")) or ""
    --         end
    --
    --         local macro_recording = function()
    --             local reg = vim.fn.reg_recording()
    --             return reg ~= "" and ("󰑋 @" .. reg) or ""
    --         end
    --
    --         local diff_source = function()
    --             local gitsigns = vim.b.gitsigns_status_dict
    --             if gitsigns then
    --                 return {
    --                     added = gitsigns.added,
    --                     modified = gitsigns.changed,
    --                     removed = gitsigns.removed,
    --                 }
    --             end
    --         end
    --
    --         require("lualine").setup({
    --             options = {
    --                 icons_enabled = true,
    --                 theme = "auto",  -- авто-тема (onedark)
    --                 component_separators = { left = "", right = "" },
    --                 section_separators = { left = "", right = "" },
    --                 globalstatus = true,
    --                 refresh = {
    --                     statusline = 100,  -- 100ms обновление
    --                     winbar = 1000,     -- реже для winbar
    --                 },
    --             },
    --             sections = {
    --                 lualine_a = {
    --                     {
    --                         "mode",
    --                         fmt = function(str)
    --                             return str:sub(1, 1)  -- N/I/V/C
    --                         end,
    --                     },
    --                 },
    --                 lualine_b = {
    --                     { "branch", icon = "󰘬" },  -- ← иконка git
    --                     {
    --                         "diff",
    --                         source = diff_source,
    --                         symbols = {
    --                             added = " ",
    --                             modified = " ",
    --                             removed = " "
    --                         },
    --                         colored = true,
    --                     },
    --                 },
    --                 lualine_c = {
    --                     {
    --                         "filename",
    --                         path = 1,
    --                         shorting_target = 50,
    --                         symbols = {
    --                             modified = " ●",
    --                             readonly = " ",
    --                             unnamed = "[No Name]",
    --                         },
    --                     },
    --                     -- Navic для Go (опционально)
    --                     -- {
    --                     --     "navic",
    --                     --     cond = function()
    --                     --         return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
    --                     --     end,
    --                     -- },
    --                 },
    --                 lualine_x = {
    --                     { macro_recording, color = { fg = "#ff9e64" } },
    --                     {
    --                         "diagnostics",
    --                         sources = { "nvim_diagnostic" },  -- ← новое имя для 0.11+
    --                         symbols = {
    --                             error = " ",
    --                             warn = " ",
    --                             info = " ",
    --                             hint = " "
    --                         },
    --                         colored = true,
    --                         update_in_insert = false,
    --                     },
    --                     { lsp_client, color = { fg = "#7dcfff" } },
    --                     "filetype",
    --                 },
    --                 lualine_y = {
    --                     { "progress", separator = " ", padding = { left = 1, right = 0 } },
    --                     { "location", padding = { left = 0, right = 1 } },
    --                 },
    --                 lualine_z = {
    --                     function()
    --                         return "󰥔 " .. os.date("%H:%M")  -- ← иконка часов
    --                     end,
    --                 },
    --             },
    --             inactive_sections = {
    --                 lualine_c = { { "filename", path = 1 } },
    --                 lualine_x = { "location" },
    --             },
    --             extensions = {
    --                 "lazy",
    --                 "mason",
    --                 "trouble",
    --                 "quickfix",
    --                 "fzf",      -- ← добавил fzf
    --                 "oil",      -- ← добавил oil
    --             },
    --         })
    --     end,
    -- },
}
