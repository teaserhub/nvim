return {
    -- ═══════════════════════════ MINI.STATUSLINE (НИЗ) ═══════════════════════════
    {
        "echasnovski/mini.statusline",
        version = "*",
        event = "VeryLazy",
        config = function()
            local statusline = require("mini.statusline")
            statusline.setup({
                use_icons = true,
                content = {
                    active = function()
                        local mode = statusline.section_mode({ trunc_width = 120 })
                        local fname = statusline.section_filename({ trunc_width = 120 })
                        local git = vim.g.gitsigns_status or ""
                        
                        local clients = vim.lsp.get_clients({ bufnr = 0 })
                        local lsp = #clients > 0 and (" 󰒋 " .. table.concat(
                            vim.tbl_map(function(c) return c.name end, clients), ","
                        )) or ""
                        
                        local counts = vim.diagnostic.count(0) or {}
                        local err = counts[vim.diagnostic.severity.ERROR] or 0
                        local warn = counts[vim.diagnostic.severity.WARN] or 0
                        local diag = ""
                        if err > 0 then diag = diag .. " 󰅚 " .. err end
                        if warn > 0 then diag = diag .. " 󰀪 " .. warn end
                        
                        local fileinfo = statusline.section_fileinfo({ trunc_width = 50 })
                        
                        -- ✅ FIX: section_position не существует. 
                        -- Используем нативные коды Vim: %l (строка), %L (всего), %c (колонка)
                        local pos = "%l/%L:%c"
                        
                        return mode .. fname .. git .. lsp .. diag .. "%=" .. fileinfo .. " " .. pos
                    end,
                },
            })
        end,
    },
    -- ═══════════════════════════ MINI.TABLINE (ВЕРХ) ═══════════════════════════
    {
        "echasnovski/mini.tabline",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("mini.tabline").setup({
                format = function(bufnr, is_current, is_visible)
                    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
                    if name == "" then name = "[No Name]" end

                    -- Иконка файла (если есть Nerd Fonts)
                    local icon = ""
                    local devicons = pcall(require, "nvim-web-devicons")
                    if devicons then
                        local ico, hl = require("nvim-web-devicons").get_icon(name)
                        if ico then icon = ico .. " " end
                    end

                    local prefix = is_current and "▸ " or "  "
                    return prefix .. icon .. name .. " "
                end,
            })
            vim.opt.showtabline = 2 -- Всегда показывать буфер-бар
        end,
    },
}
