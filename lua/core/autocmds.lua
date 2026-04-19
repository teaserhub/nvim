-- ~/.config/nvim/lua/core/autocmds.lua
local aucmd = vim.api.nvim_create_autocmd

-- Подсветка скопированного текста
aucmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

-- Go использует табы, не пробелы
aucmd("FileType", {
    pattern = "go",
    callback = function()
        vim.opt_local.expandtab = false
    end,
})

-- ✅ АВТОСОХРАНЕНИЕ БУФЕРОВ
-- При потере фокуса (переключился в другое окно)
aucmd("FocusLost", {
    pattern = "*",
    callback = function()
        if vim.bo.modified and not vim.bo.readonly and vim.bo.buftype == "" then
            vim.cmd("silent! wall")
        end
    end,
})

-- При выходе из insert mode (опционально)
aucmd("InsertLeave", {
    pattern = "*",
    callback = function()
        if vim.bo.modified and not vim.bo.readonly and vim.bo.buftype == "" then
            vim.cmd("silent! update")
        end
    end,
})

-- Перед выходом из Neovim (на всякий случай)
aucmd("VimLeavePre", {
    pattern = "*",
    callback = function()
        vim.cmd("silent! wall")
    end,
})

-- Автосохранение каждые 3 секунды (если есть изменения)
local save_timer = vim.loop.new_timer()
save_timer:start(0, 3000, vim.schedule_wrap(function()
    local ok = pcall(function()
        if vim.bo.modified and not vim.bo.readonly and vim.bo.buftype == "" then
            vim.cmd("silent! update")
        end
    end)
end))

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.lsp.enable("gopls")
  end,
})

-- -- Вместо автокоманды для Go
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "*",
--     callback = function()
--         if pcall(vim.treesitter.start) then
--             -- Treesitter поддерживает этот тип файла
--         end
--     end,
-- })
--

