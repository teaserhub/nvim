-- lua/plugins/ai.lua
return {
    {
        "Exafunction/codeium.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("codeium").setup({
                enable_chat = true,
            })
        end,
    },
}
