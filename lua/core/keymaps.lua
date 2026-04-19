-- core/keymaps.lua
-- Все клавиши в одном месте (как routes.go в web-сервере)
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Лидер как в "консольных" редакторах
vim.g.mapleader = " "

-- Мои клавиши
map('i', 'jj', '<Esc>')

-- Выход и сохранение
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")

-- Buffer context
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close current buffer" })
map("n", "<leader>bD", function()
    local cur = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= cur and vim.bo[buf].buflisted then
            pcall(vim.cmd, "bd " .. buf)
        end
    end
end, { desc = "Close all except current" })
map("n", "<leader>bo", "<C-w>o", { desc = "Close other splits" })

-- Навигация между сплитами как в терминале (tmux-like)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Удалить встроенный K (man)
map("n", "K", "<Nop>", { silent = true })

map("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" })
-- =============================================================================
--  Пользовательские хоткеи (после lazy)
-- =============================================================================

-- 🔹 Дублирование строк вниз/вверх (КОПИРОВАНИЕ, не перемещение!)
map("n", "<C-d>", "<cmd>t .<cr>", { desc = "Дублировать строку вниз" })
map("n", "<C-u>", "<cmd>t .-2<cr>", { desc = "Дублировать строку вверх" })
map("v", "<C-d>", ":m '>+1<cr>gv=gv", { desc = "Дублировать выделение вниз" })
map("v", "<C-u>", ":m '<-2<cr>gv=gv", { desc = "Дублировать выделение вверх" })

-- 🔹 Очистка подсветки поиска
map("n", "<leader><Esc>", ":noh<cr>", { desc = "Очистить поиск" })

-- =============================================================================
--  Копирование / Вставка / Выделение (VS Code style)
-- =============================================================================

-- 🔹 Ctrl+A: Выделить весь файл
map("n", "<C-a>", "ggVG", { desc = "Выделить весь файл" })
map("i", "<C-a>", "<Esc>ggVG", { desc = "Выделить весь файл" })

-- 🔹 Ctrl+C: Копировать (в визуальном режиме)
map("v", "<C-c>", '"+y', { desc = "Копировать в системный буфер" })

-- 🔹 Ctrl+V: Вставить
map("n", "<C-v>", '"+p', { desc = "Вставить из системного буфера" })
map("i", "<C-v>", "<C-r>+", { desc = "Вставить из системного буфера" })
map("v", "<C-v>", '"+p', { desc = "Вставить и заменить выделение" })

-- 🔹 Ctrl+X: Вырезать (в визуальном режиме)
map("v", "<C-x>", '"+x', { desc = "Вырезать в системный буфер" })

-- 🔹 Ctrl+Z: Отменить
map("n", "<C-z>", "u", { desc = "Отменить" })
map("i", "<C-z>", "<C-o>u", { desc = "Отменить" })

-- 🔹 Ctrl+Y: Вернуть (Redo)
map("n", "<C-y>", "<C-r>", { desc = "Вернуть" })
map("i", "<C-y>", "<C-o><C-r>", { desc = "Вернуть" })

-- 🔹 Ctrl+S: Сохранить (для привычки)
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Сохранить файл" })
map("i", "<C-s>", "<cmd>w<cr>", { desc = "Сохранить файл" })

-- 🔹 Ctrl+F: Поиск (открывает fzf)
map("n", "<C-f>", "<cmd>FzfLua files<cr>", { desc = "Поиск файлов" })

-- 🔹 Ctrl+H: Заменить (открывает fzf live_grep)
map("n", "<C-g>", "<cmd>FzfLua live_grep<cr>", { desc = "Поиск по тексту" })
