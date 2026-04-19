return {
    {
        url = "https://codeberg.org/andyg/leap.nvim",
        keys = {
            { "s",  mode = { "n", "x", "o" }, desc = "Leap forward" },
            { "S",  mode = { "n", "x", "o" }, desc = "Leap backward" },
            { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
        },
        config = function()
            require("leap").setup({
                case_sensitive = false,
                equivalence_classes = { " \t\r\n", },
                max_phase_one_targets = nil,
                max_highlighted_traversal_targets = 10,
                substitute_chars = {},
                safe_labels = {
                    "s", "f", "n", "j", "k", "l", "h", "o", "d", "w",
                    "e", "m", "b", "u", "y", "v", "r", "g", "t", "c",
                },
                
                -- Новый способ подсветки (вместо highlight_unlabeled_phase_one_targets)
                on_beacons = function(targets)
                    for _, t in ipairs(targets) do
                        if not t.label and not t.beacon and t.chars and t.is_previewable ~= false then
                            t.beacon = { 0, { virt_text = { { table.concat(t.chars), "LeapMatch" } } } }
                        end
                    end
                end,
            })
            
            -- Маппинги
            vim.keymap.set({ "n", "x", "o" }, "s",  "<Plug>(leap-forward)")
            vim.keymap.set({ "n", "x", "o" }, "S",  "<Plug>(leap-backward)")
            vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
            
            -- Прыжки по синтаксическому дереву
            vim.keymap.set({ "n", "x", "o" }, "sa", function()
                require("leap.treesitter").select()
            end, { desc = "Leap AST" })
        end,
    },
}
