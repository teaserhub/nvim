local map = vim.keymap.set

vim.g.mapleader = " "

-- выход из терминала
map("t", "<Esc>", [[<C-\><C-n>]])

-- быстрые действия
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")

-- buffers
map("n", "<leader>bd", "<cmd>bdelete<cr>")
-- map({ "n", "t" }, "<C-\\>", "<cmd>ToggleTerm<cr>")
-- yazi
-- открыть oil в cwd

-- открыть в директории текущего файла
