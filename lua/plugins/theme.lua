-- lua/plugins/theme.lua
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false, -- обязательно загружать сразу
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = false,
            integrations = {
                bufferline = true,
                nvimtree = true,
                telescope = true,
                treesitter = true,
                which_key = true,
                gitsigns = true,
                lsp_trouble = true,
            },
        })
        vim.cmd.colorscheme("catppuccin")
    end,
}
