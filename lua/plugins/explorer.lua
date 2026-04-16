return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    config = function()
        require("neo-tree").setup({
            close_if_last_window = false,
            popup_border_style = "rounded",

            -- === Оптимизации скорости ===
            enable_git_status = true,
            enable_diagnostics = false, -- выключаем, если не критично
            use_populators = false,
            async_directory_scan = "always",

            window = {
                position = "left",
                width = 32, -- уже = быстрее
                mappings = {
                    ["<space>"] = "toggle_node",
                    ["<cr>"] = "open",
                    ["P"] = "toggle_preview",
                },
            },

            filesystem = {
                filtered_items = {
                    visible = false,
                    hide_dotfiles = false,
                    hide_gitignored = true,
                },
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                scan_mode = "shallow", -- важно для скорости
                hijack_netrw_behavior = "open_default",
            },

            default_component_configs = {
                indent = { padding = 1 },
                icon = { folder_closed = "", folder_open = "" },
            },
        })
    end,
}
