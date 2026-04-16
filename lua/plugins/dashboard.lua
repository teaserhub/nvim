-- lua/plugins/dashboard.lua
return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
            "   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
            "   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
            "   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
            "   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
            "   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
            "   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        }

        dashboard.section.buttons.val = {
            dashboard.button("f", "󰈞  Find File", ":Telescope find_files<CR>"),
            dashboard.button("g", "󰊄  Live Grep", ":Telescope live_grep<CR>"),
            dashboard.button("n", "  New File", ":ene <BAR> startinsert<CR>"),
            dashboard.button("r", "󱋡  Recent Files", ":Telescope oldfiles<CR>"),
            dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua<CR>"),
            dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
        }

        alpha.setup(dashboard.config)
    end,
}
