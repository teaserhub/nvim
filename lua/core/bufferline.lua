-- lua/core/bufferline.lua
local M = {}

function M.render()
    local buffers = {}
    local current_buf = vim.api.nvim_get_current_buf()
    
    -- 1. Собираем все буферы, которые нужно показать
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        -- Пропускаем невидимые буферы (help, terminal без файлов и т.д.)
        if vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_loaded(bufnr) then
            table.insert(buffers, bufnr)
        end
    end
    
    -- 2. Сортируем по номеру буфера (можно по lastused)
    table.sort(buffers, function(a, b)
        return a < b
    end)
    
    -- 3. Собираем строку
    local result = ""
    
    for _, bufnr in ipairs(buffers) do
        -- Имя файла
        local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
        if name == "" then name = "[No Name]" end
        
        -- Highlight для текущего буфера
        if bufnr == current_buf then
            result = result .. "%#TabLineSel#"
        else
            result = result .. "%#TabLine#"
        end
        
        -- Добавляем имя
        result = result .. " " .. name .. " "
    end
    
    return result .. "%#TabLineFill#"
end

return M
