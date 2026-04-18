local map = vim.keymap.set

vim.g.mapleader = " "

-- выход из терминала
map("t", "<Esc>", [[<C-\><C-n>]])

-- быстрые действия
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")

vim.keymap.set("n", "<Tab>", ":bnext<CR>")
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>")

-- buffers
map("n", "<leader>bd", "<cmd>bdelete<cr>")
-- map({ "n", "t" }, "<C-\\>", "<cmd>ToggleTerm<cr>")
-- yazi
-- открыть oil в cwd
-- =============================================================================
--  Пользовательские хоткеи (после lazy)
-- =============================================================================

-- 🔹 Дублирование строк вниз/вверх (КОПИРОВАНИЕ, не перемещение!)
vim.keymap.set("n", "<C-d>", "<cmd>t .<cr>", { desc = "Дублировать строку вниз" })
vim.keymap.set("n", "<C-u>", "<cmd>t .-2<cr>", { desc = "Дублировать строку вверх" })
vim.keymap.set("v", "<C-d>", ":m '>+1<cr>gv=gv", { desc = "Дублировать выделение вниз" })
vim.keymap.set("v", "<C-u>", ":m '<-2<cr>gv=gv", { desc = "Дублировать выделение вверх" })

-- 🔹 Очистка подсветки поиска
vim.keymap.set("n", "<leader><Esc>", ":noh<cr>", { desc = "Очистить поиск" })

-- 🔹 Альтернативное комментирование (опционально)
-- vim.keymap.set("n", "<leader>/", "gcc", { desc = "Закомментировать строку" })
-- vim.keymap.set("v", "<leader>/", "gc", { desc = "Закомментировать выделение" })

-- =============================================================================
--  Копирование / Вставка / Выделение (VS Code style)
-- =============================================================================

-- 🔹 Ctrl+A: Выделить весь файл
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Выделить весь файл" })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { desc = "Выделить весь файл" })

-- 🔹 Ctrl+C: Копировать (в визуальном режиме)
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Копировать в системный буфер" })

-- 🔹 Ctrl+V: Вставить
vim.keymap.set("n", "<C-v>", '"+p', { desc = "Вставить из системного буфера" })
vim.keymap.set("i", "<C-v>", "<C-r>+", { desc = "Вставить из системного буфера" })
vim.keymap.set("v", "<C-v>", '"+p', { desc = "Вставить и заменить выделение" })

-- 🔹 Ctrl+X: Вырезать (в визуальном режиме)
vim.keymap.set("v", "<C-x>", '"+x', { desc = "Вырезать в системный буфер" })

-- 🔹 Ctrl+Z: Отменить
vim.keymap.set("n", "<C-z>", "u", { desc = "Отменить" })
vim.keymap.set("i", "<C-z>", "<C-o>u", { desc = "Отменить" })

-- 🔹 Ctrl+Y: Вернуть (Redo)
vim.keymap.set("n", "<C-y>", "<C-r>", { desc = "Вернуть" })
vim.keymap.set("i", "<C-y>", "<C-o><C-r>", { desc = "Вернуть" })

-- 🔹 Ctrl+S: Сохранить (для привычки)
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Сохранить файл" })
vim.keymap.set("i", "<C-s>", "<cmd>w<cr>", { desc = "Сохранить файл" })

-- 🔹 Ctrl+F: Поиск (открывает fzf)
vim.keymap.set("n", "<C-f>", "<cmd>FzfLua files<cr>", { desc = "Поиск файлов" })

-- 🔹 Ctrl+H: Заменить (открывает fzf live_grep)
vim.keymap.set("n", "<C-h>", "<cmd>FzfLua live_grep<cr>", { desc = "Поиск по тексту" })
