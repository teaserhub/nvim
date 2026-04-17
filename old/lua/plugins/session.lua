-- lua/plugins/session.lua
return {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
        require("persistence").setup({
            dir = vim.fn.stdpath("state") .. "/sessions/",
            options = { "buffers", "curdir", "tabpages", "winsize" },
        })

        -- Восстанавливать сессию автоматически при старте
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                if vim.fn.argc() == 0 then
                    require("persistence").load()
                end
            end,
        })

        vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore Session" })
        vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end,
            { desc = "Restore Last Session" })
        vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end,
            { desc = "Don't Save Current Session" })
    end,
}
