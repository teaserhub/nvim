-- lua/plugins/comment.lua
return {
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup({
            -- Более удобные клавиши
            toggler = {
                line = 'gcc', -- Комментировать/раскомментировать строку
                block = 'gbc', -- Комментировать/раскомментировать блок
            },
            opleader = {
                line = 'gc', -- Комментировать выделенное (визуальный режим)
                block = 'gb',
            },
        })

        -- Дополнительные удобные клавиши
        local map = vim.keymap.set
        map("n", "<C-/>", "gcc", { desc = "Comment Line", remap = true })
        map("v", "<C-/>", "gc", { desc = "Comment Selection", remap = true })
        map("n", "<C-_>", "gcc", { desc = "Comment Line", remap = true }) -- для некоторых клавиатур
    end,
}
