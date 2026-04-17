-- lua/plugins/zenmode.lua
return {
    "folke/zen-mode.nvim",
    config = function()
        require("zen-mode").setup({
            window = {
                width = 0.85, -- 85% ширины экрана
                options = {
                    number = false,
                    relativenumber = false,
                    cursorline = false,
                },
            },
        })

        vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { desc = "Zen Mode" })
    end,
}
