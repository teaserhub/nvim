return {
    "echasnovski/mini.starter",
    event = "VimEnter",
    config = function()
        local starter = require("mini.starter")
        starter.setup({
            evaluate_single = true,
            items = {
                starter.sections.recent_files(10, false),
                starter.sections.builtin_actions(),
            },
            header = table.concat({
                "                                   ",
                "   N E O V I M   +   G O            ",
                "                                   ",
            }, "\n"),
        })
    end,
}
