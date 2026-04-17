-- lua/plugins/emmet.lua
return {
    {
        "olrtg/nvim-emmet",
        config = function()
            vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation,
                { desc = "Emmet: Wrap Abbreviation" })
        end,
    },
}
