-- plugins/specs/snacks.lua
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        notify = { enabled = true },
        dashboard = {
            enabled = true,
            preset = {
                header = table.concat({
                    "                                   ",
                    "   N E O V I M   +   G O            ",
                    "                                   ",
                }, "\n"),
            },
            sections = {
                { section = "recent_files", limit = 10, cwd = false },
                { section = "keys", gap = 1, padding = 1 },
            },
        },
    },
}
