return {
    "ibhagwan/fzf-lua",
    config = function()
        local fzf = require("fzf-lua")

        vim.keymap.set("n", "<leader>ff", fzf.files)
        vim.keymap.set("n", "<leader>fg", fzf.live_grep)
        vim.keymap.set("n", "<leader>fb", fzf.buffers)
    end
}
