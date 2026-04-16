local Terminal = require("toggleterm.terminal").Terminal

-- Go run
local run = Terminal:new({
  cmd = "go run .",
  direction = "float",
})

-- Go test
local test = Terminal:new({
  cmd = "go test ./...",
  direction = "float",
})

-- Git UI (lazygit если установлен)
local lazygit = Terminal:new({
  cmd = "lazygit",
  direction = "float",
})

vim.keymap.set("n", "<leader>tr", function() run:toggle() end, { desc = "Go Run" })
vim.keymap.set("n", "<leader>tt", function() test:toggle() end, { desc = "Go Test" })
vim.keymap.set("n", "<leader>tg", function() lazygit:toggle() end, { desc = "Git UI" })
