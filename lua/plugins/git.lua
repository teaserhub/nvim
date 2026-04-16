return {
  "lewis6991/gitsigns.nvim",

  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
      },

      current_line_blame = true, -- 🔥 показывает кто изменил строку
    })

    local gs = package.loaded.gitsigns
    local map = vim.keymap.set

    -- ==================== GIT ACTIONS ====================

  --  map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
--    map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset Hunk" })
  --  map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset Buffer" })
   -- map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage Hunk" })
   -- map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Unstage Hunk" })

    -- map("n", "<leader>gd", gs.diffthis, { desc = "Diff File" })
  end,
}
