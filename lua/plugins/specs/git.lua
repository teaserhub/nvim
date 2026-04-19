return {
    -- 1. Gitsigns (инлайн-дифф в буфере)
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "┃" },
                change = { text = "┃" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            watch_gitdir = { follow_files = true },
            attach_to_untracked = true,
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 800,
                ignore_whitespace = false,
            },
            preview_config = {
                border = "rounded",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
        },
        keys = {
            { "<leader>gh", function() require("gitsigns").stage_hunk() end, desc = "Stage Hunk" },
            { "<leader>gH", function() require("gitsigns").undo_stage_hunk() end, desc = "Undo Stage" },
            { "<leader>gr", function() require("gitsigns").reset_hunk() end, desc = "Reset Hunk" },
            { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "Preview Hunk" },
            { "<leader>gb", function() require("gitsigns").blame_line() end, desc = "Blame Line" },
            { "<leader>gd", function() require("gitsigns").diffthis() end, desc = "Diff This" },
            { "[h", function() require("gitsigns").nav_hunk("prev") end, desc = "Prev Hunk" },
            { "]h", function() require("gitsigns").nav_hunk("next") end, desc = "Next Hunk" },
        },
    },

    -- 2. Diffview (сравнение веток/коммитов) — у тебя уже есть
{
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
        { "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Diffview (current)" },
        { "<leader>gV", "<cmd>DiffviewFileHistory %<CR>", desc = "File History" },
        { "<leader>gl", "<cmd>DiffviewFileHistory --range=HEAD~20..<CR>", desc = "Last 20 Commits" },
    },
    opts = {
        enhanced_diff_hl = true,
        view = {
            default = { layout = "diff2_horizontal" },
            file_history = { layout = "diff2_horizontal" },
        },
        hooks = {
            diff_buf_win_enter = function()
                vim.opt_local.wrap = false
                vim.opt_local.number = true
                vim.opt_local.relativenumber = true
                -- q работает в любом окне
                vim.keymap.set("n", "q", "<cmd>DiffviewClose<CR>", { buffer = true, desc = "Close Diffview" })
            end,
        },
    },
},

    -- 3. Fugitive (Git-команды)
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gstatus", "Gcommit", "Gpush", "Gpull", "Gblame" },
        keys = {
            { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
            { "<leader>gc", "<cmd>Git commit<CR>", desc = "Git commit" },
            { "<leader>gP", "<cmd>Git push<CR>", desc = "Git push" },
            { "<leader>gu", "<cmd>Git pull<CR>", desc = "Git pull" },
            { "<leader>gB", "<cmd>Git blame<CR>", desc = "Git blame" },
            { "<leader>gD", "<cmd>Gdiffsplit<CR>", desc = "Git diff" },
        },
    },

    -- 4. Flog (граф коммитов)
    -- {
    --     "rbong/vim-flog",
    --     cmd = { "Flog", "Flogsplit", "Floggit" },
    --     dependencies = { "tpope/vim-fugitive" },
    --     keys = {
    --         { "<leader>gL", "<cmd>Flog<CR>", desc = "Git log (graph)" },
    --         { "<leader>gS", "<cmd>Flogsplit<CR>", desc = "Git log (split)" },
    --     },
    --     config = function()
    --         vim.g.flog_default_arguments = {
    --             max_count = 100,
    --             date = "relative",
    --             graph = true,
    --         }
    --
    --         -- Закрыть Flog по q
    --         vim.api.nvim_create_autocmd("FileType", {
    --             pattern = "floggraph",
    --             callback = function()
    --                 vim.keymap.set("n", "q", "<cmd>q<CR>", { buffer = true })
    --             end,
    --         })
    --     end,
    -- },
}
