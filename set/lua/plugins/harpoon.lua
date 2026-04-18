return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2", -- сейчас это актуальная v2
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true, -- автосохранение списка при закрытии
      },
    })

    -- 🔑 Хоткеи
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end,
      { desc = "Harpoon: Добавить текущий файл" })
    vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Harpoon: Открыть меню" })

    -- Быстрые переходы 1-4
    for i = 1, 4 do
      vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end,
        { desc = "Harpoon: Перейти к файлу " .. i })
    end
  end,
}
