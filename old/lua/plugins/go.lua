-- lua/plugins/go.lua
return {
    "ray-x/go.nvim",
    dependencies = {
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("go").setup({
            goimports = "gopls",
            gofmt = "gofumpt",
            lsp_cfg = false, -- используем mason
            lsp_on_attach = true,
            dap_debug = true,
        })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod", "gowork" },
    build = ':lua require("go.install").update_all_sync()',
}
