-- ~/.config/nvim/autocmds.lua
local aucmd = vim.api.nvim_create_autocmd

-- Подсветка скопированного текста
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

-- Go использует табы, не пробелы
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.opt_local.expandtab = false
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

