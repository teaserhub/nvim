-- ~/.config/nvim/lua/plugins/oil.lua
return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- опционально, но красиво
  opts = {
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      natural_order = true,
    },
    float = {
      max_width = 0.6,      -- 60% ширины экрана
      max_height = 0.7,     -- 70% высоты экрана
      border = "rounded",   -- скруглённые границы
    },
    -- Клавиши внутри самого oil-окна
    keymaps = {
  ["<Esc>"] = "actions.close",
  ["q"]     = "actions.close",
  ["<CR>"]  = "actions.select",
  ["-"]     = "actions.parent",       -- на уровень вверх
  ["~"]     = "actions.open_cwd",     -- в домашнюю директорию
  ["`"]     = "actions.cd",           -- сделать текущую папку cwd
  ["<leader>s"] = function()          -- быстрое сохранение изменений
    require("oil").save()
    require("oil").close()
  end,
},
  },
  -- Глобальный хоткей для открытия/закрытия popup
  keys = {
    {
      "<leader>e",
      function()
        local oil = require("oil")
        -- Проверяем, есть ли уже открытое окно oil
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "oil" then
            oil.close()
            return
          end
        end
        oil.open_float()
      end,
      desc = "Toggle oil.nvim (popup)",
    },
  },
}
