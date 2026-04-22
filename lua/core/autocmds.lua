-- =============================================================================
-- ~/.config/nvim/lua/core/autocmds.lua
-- Neovim 0.11+ | 2026
-- =============================================================================

local api   = vim.api
local uv    = vim.uv        -- официальный alias (vim.loop deprecated)
local aucmd = api.nvim_create_autocmd
local augrp = api.nvim_create_augroup

-- =============================================================================
-- HELPERS
-- =============================================================================

--- Возвращает true, если текущий буфер можно сохранять
local function is_saveable()
    local bo = vim.bo
    return bo.modified
        and not bo.readonly
        and bo.buftype == ""
        and bo.filetype ~= ""          -- не сохраняем пустые scratch-буферы
        and api.nvim_buf_get_name(0) ~= ""  -- буфер должен иметь имя (путь)
end

-- =============================================================================
-- ГРУППЫ (каждая группа — своя зона ответственности, clear=true предотвращает
-- дублирование при повторном source файла)
-- =============================================================================

local G = {
    yank      = augrp("core_yank",      { clear = true }),
    autosave  = augrp("core_autosave",  { clear = true }),
    filetypes = augrp("core_filetypes", { clear = true }),
    ui        = augrp("core_ui",        { clear = true }),
    editing   = augrp("core_editing",   { clear = true }),
}

-- =============================================================================
-- 1. YANK — подсветка скопированного текста
-- =============================================================================

aucmd("TextYankPost", {
    group    = G.yank,
    desc     = "Highlight yanked text",
    callback = function()
        vim.hl.on_yank({ higroup = "IncSearch", timeout = 180 })
    end,
})

-- =============================================================================
-- 2. AUTOSAVE
-- =============================================================================

-- При выходе из Insert mode
aucmd("InsertLeave", {
    group    = G.autosave,
    desc     = "Autosave on InsertLeave",
    callback = function()
        if is_saveable() then
            vim.cmd("silent! update")
        end
    end,
})

-- При потере фокуса окном Neovim
aucmd("FocusLost", {
    group    = G.autosave,
    desc     = "Autosave on FocusLost",
    callback = function()
        if is_saveable() then
            vim.cmd("silent! wall")
        end
    end,
})

-- При переключении на другой буфер (удобно при работе с несколькими файлами)
aucmd("BufLeave", {
    group    = G.autosave,
    desc     = "Autosave on BufLeave",
    callback = function()
        if is_saveable() then
            vim.cmd("silent! update")
        end
    end,
})

-- Перед выходом из Neovim — сохраняем всё
aucmd("VimLeavePre", {
    group    = G.autosave,
    desc     = "Save all buffers before exit",
    callback = function()
        vim.cmd("silent! wall")
    end,
})

-- Таймер-автосохранение каждые 30 секунд (разумный интервал, не каждые 3)
-- Используем vim.uv (не vim.loop — deprecated с 0.10)
do
    local timer = uv.new_timer()
    if timer then
        timer:start(30000, 30000, vim.schedule_wrap(function()
            -- Проверяем все буферы, не только текущий
            for _, buf in ipairs(api.nvim_list_bufs()) do
                if api.nvim_buf_is_loaded(buf) then
                    local bo = vim.bo[buf]
                    local name = api.nvim_buf_get_name(buf)
                    if bo.modified
                        and not bo.readonly
                        and bo.buftype == ""
                        and bo.filetype ~= ""
                        and name ~= ""
                    then
                        -- pcall: на случай если файл удалён с диска
                        pcall(api.nvim_buf_call, buf, function()
                            vim.cmd("silent! update")
                        end)
                    end
                end
            end
        end))

        -- Чистим таймер при выходе из Neovim
        aucmd("VimLeavePre", {
            group    = G.autosave,
            desc     = "Stop autosave timer",
            callback = function()
                if not timer:is_closing() then
                    timer:stop()
                    timer:close()
                end
            end,
        })
    end
end

-- =============================================================================
-- 3. FILETYPES — настройки под конкретные языки
-- =============================================================================

-- Go: табы, ширина, LSP
aucmd("FileType", {
    group    = G.filetypes,
    pattern  = "go",
    desc     = "Go: tabs + gopls",
    callback = function()
        local opt = vim.opt_local
        opt.expandtab  = false
        opt.tabstop    = 4
        opt.shiftwidth = 4

        -- vim.lsp.enable — Neovim 0.11+ API
        if vim.lsp and vim.lsp.enable then
            vim.lsp.enable("gopls")
        end
    end,
})

-- Python: PEP8
aucmd("FileType", {
    group    = G.filetypes,
    pattern  = { "python" },
    desc     = "Python: PEP8 indentation",
    callback = function()
        local opt = vim.opt_local
        opt.expandtab  = true
        opt.tabstop    = 4
        opt.shiftwidth = 4
    end,
})

-- Web / конфиги: 2 пробела
aucmd("FileType", {
    group    = G.filetypes,
    pattern  = { "javascript", "typescript", "javascriptreact", "typescriptreact",
                 "json", "yaml", "toml", "html", "css", "scss", "lua" },
    desc     = "Web/config: 2-space indentation",
    callback = function()
        local opt = vim.opt_local
        opt.expandtab  = true
        opt.tabstop    = 2
        opt.shiftwidth = 2
    end,
})

-- Markdown / text: перенос слов
aucmd("FileType", {
    group    = G.filetypes,
    pattern  = { "markdown", "text", "rst" },
    desc     = "Prose: wrap + spell",
    callback = function()
        local opt = vim.opt_local
        opt.wrap      = true
        opt.linebreak = true
        opt.spell     = true
        opt.spelllang = { "en_us", "ru" }
    end,
})

-- =============================================================================
-- 4. UI / WINDOWS
-- =============================================================================

-- Восстанавливаем позицию курсора при открытии файла
aucmd("BufReadPost", {
    group    = G.ui,
    desc     = "Restore cursor position",
    callback = function()
        local mark = api.nvim_buf_get_mark(0, '"')
        local line_count = api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Автоматически выравниваем окна при изменении размера терминала
aucmd("VimResized", {
    group    = G.ui,
    desc     = "Resize splits on terminal resize",
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Убираем trailing whitespace при сохранении (только в коде, не в Markdown)
aucmd("BufWritePre", {
    group    = G.ui,
    desc     = "Strip trailing whitespace",
    callback = function()
        local ft = vim.bo.filetype
        local skip = { markdown = true, text = true, rst = true }
        if not skip[ft] then
            local view = vim.fn.winsaveview()
            vim.cmd([[silent! %s/\s\+$//e]])
            vim.fn.winrestview(view)
        end
    end,
})

-- Подсвечиваем строку только в активном окне
aucmd({ "WinEnter", "BufEnter" }, {
    group    = G.ui,
    desc     = "Cursorline only in active window",
    callback = function() vim.opt_local.cursorline = true end,
})

aucmd({ "WinLeave" }, {
    group    = G.ui,
    desc     = "Hide cursorline in inactive window",
    callback = function() vim.opt_local.cursorline = false end,
})

-- =============================================================================
-- 5. EDITING UX
-- =============================================================================

-- q закрывает служебные окна (quickfix, help, man и др.)
aucmd("FileType", {
    group    = G.editing,
    pattern  = { "help", "man", "qf", "query", "notify",
                 "lspinfo", "startuptime", "checkhealth" },
    desc     = "Close auxiliary windows with q",
    callback = function(ev)
        vim.keymap.set("n", "q", "<cmd>close<cr>",
            { buffer = ev.buf, silent = true, desc = "Close window" })
    end,
})

-- Не добавляем комментарий автоматически при Enter / o / O
aucmd("BufEnter", {
    group    = G.editing,
    desc     = "Disable auto-comment on newline",
    callback = function()
        vim.opt_local.formatoptions:remove({ "r", "o" })
    end,
})

-- Автоформатирование при сохранении
-- aucmd("BufWritePre", {
--     group    = G.editing,
--     desc     = "Format on save via LSP",
--     callback = function()
--         local bo = vim.bo
--         if bo.buftype == "" and bo.filetype ~= "" then
--             vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
--         end
--     end,
-- })

aucmd("InsertLeave", {
    group    = G.editing,
    desc     = "Format on InsertLeave",
    callback = function()
        local bo = vim.bo
        if bo.buftype == "" and bo.filetype ~= "" then
            vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
        end
    end,
})

-- =============================================================================
-- 6. КАСТОМНЫЕ HIGHLIGHTS (treesitter-совместимые)
-- Применяем и сразу, и при каждой смене colorscheme
-- =============================================================================

local function apply_highlights()
    -- Treesitter захватчики (@-синтаксис, актуальный для nvim-treesitter v0.9+)
    local hls = {
        ["@function"]         = { fg = "#61afef",},
        ["@function.call"]    = { fg = "#56b6c2" },
        ["@function.method"]  = { fg = "#61afef" },
        ["@type"]             = { fg = "#e5c07b" },
        ["@type.builtin"]     = { fg = "#e5c07b", italic = true },
        ["@keyword"]          = { fg = "#c678dd", bold = true },
        ["@keyword.return"]   = { fg = "#c678dd" },
        ["@string"]           = { fg = "#98c379" },
        ["@string.escape"]    = { fg = "#56b6c2" },
        ["@comment"]          = { fg = "#5c6370", italic = true },
        ["@variable"]         = { fg = "#e06c75", },
        ["@variable.go"]      = { fg = "#56b6c2", }, -- ✅ Пакеты Go$
        ["@variable.builtin"] = { fg = "#e06c75", italic = true },
        ["@parameter"]        = { fg = "#e06c75" },      -- deprecated → @variable.parameter
        ["@variable.parameter"] = { fg = "#e06c75" },   -- новый захватчик (TS v0.9+)
        ["@field"]            = { fg = "#e5c07b" },      -- deprecated → @variable.member
        ["@variable.member"]  = { fg = "#e5c07b" },      -- новый захватчик
        ["@constant"]         = { fg = "#d19a66" },
        ["@constant.builtin"] = { fg = "#d19a66", bold = true },
        ["@operator"]         = { fg = "#abb2bf" },
        ["@punctuation.bracket"] = { fg = "#abb2bf" },
    }

    for name, val in pairs(hls) do
        api.nvim_set_hl(0, name, val)
    end
end

aucmd("ColorScheme", {
    group    = G.ui,
    pattern  = "*",
    desc     = "Re-apply custom treesitter highlights",
    callback = apply_highlights,
})

-- Применяем немедленно (colorscheme уже могла загрузиться до этого файла)
apply_highlights()
