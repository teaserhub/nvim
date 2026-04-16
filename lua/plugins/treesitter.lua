-- lua/plugins/treesitter.lua
return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.config").setup({
            ensure_installed = { "go", "gomod", "gosum", "gowork", "lua", "markdown", "markdown_inline" },
            highlight = { enable = true },
            indent = { enable = true },
            auto_install = true,
        })
    end,
}
