-- lua/plugins/filebrowser.lua
return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    telescope.load_extension("file_browser")

    -- Основные клавиши
    vim.keymap.set("n", "<leader>e", function()
      telescope.extensions.file_browser.file_browser({
        path = "%:p:h",
        cwd = vim.fn.getcwd(),
        respect_gitignore = false,
        hidden = true,
        grouped = true,
        previewer = false,
        initial_mode = "normal",
      })
    end, { desc = "Open File Browser (Telescope)" })
  end,
}
