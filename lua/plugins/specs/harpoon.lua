return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>a", desc = "Add to Harpoon" },
        { "<leader>h", desc = "Harpoon Menu" },
        { "<leader>1", desc = "Harpoon 1" },
        { "<leader>2", desc = "Harpoon 2" },
        { "<leader>3", desc = "Harpoon 3" },
        { "<leader>4", desc = "Harpoon 4" },
    },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup({
            menu = { width = vim.api.nvim_win_get_width(0) - 4 },
            settings = { save_on_toggle = true },
        })

        -- Хоткеи
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Add to Harpoon" })
        vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Menu" })

        for i = 1, 4 do
            vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end, { desc = "Harpoon " .. i })
        end
    end,
}
