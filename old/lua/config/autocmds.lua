-- lua/config/autocmds.lua

-- Автосохранение (как в VSCode)
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    pattern = "*",
    callback = function()
        if vim.bo.buftype == "" and vim.bo.modifiable then
            vim.cmd("silent! write")
        end
    end,
    desc = "Auto save on change",
})

-- Автоформатирование Go при сохранении (уже было)
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        require("go.format").goimports()
    end,
})
