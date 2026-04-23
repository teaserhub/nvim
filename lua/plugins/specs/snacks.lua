-- В plugins/specs/ добавь:
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        notify = { enabled = true },  -- ← включить для noice
    },
}
