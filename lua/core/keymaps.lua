-- core/keymaps.lua
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Лидер как в "консольных" редакторах
vim.g.mapleader = " "

-- Мои клавиши
map('i', 'jj', '<Esc>')

-- Выход и сохранение
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")

-- Показать ошибку под курсором (всплывающее окно)
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
-- Логи (Neovim 0.12)
map("n", "<leader>ll", function()
    vim.cmd("edit " .. vim.lsp.get_log_path())
end, { desc = "LSP log" })

map("n", "<leader>lc", "<cmd>ConformInfo<cr>", { desc = "Conform info" })

map("n", "<leader>lm", function()
    vim.cmd("edit " .. vim.fn.stdpath("state") .. "/mason.log")
end, { desc = "Mason log" })

map("n", "<leader>ln", "<cmd>NoiceHistory<cr>", { desc = "Noice history" })

map("n", "<leader>lz", "<cmd>Lazy<cr>l", { desc = "Lazy log" })

map("n", "<leader>msg", "<cmd>messages<cr>", { desc = "Messages" })
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
-- map("n", "K", "<Nop>", { silent = true })

map("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" })
-- =============================================================================
--  Пользовательские хоткеи (после lazy)
-- =============================================================================

-- 🔹 Дублирование строк вниз/вверх (КОПИРОВАНИЕ, не перемещение!)
map("n", "<C-d>", "<cmd>t .<cr>", { desc = "Дублировать строку вниз" })
map("n", "<C-u>", "<cmd>t .-1<cr>", { desc = "Дублировать строку вверх" })
map("v", "<C-d>", ":m '>+2<cr>gv=gv", { desc = "Дублировать выделение вниз" })
map("v", "<C-u>", ":m '<-1<cr>gv=gv", { desc = "Дублировать выделение вверх" })

-- 🔹 Очистка подсветки поиска
map("n", "<leader><Esc>", ":noh<cr>", { desc = "Очистить поиск" })

-- =============================================================================
--  Копирование / Вставка / Выделение (VS Code style)
-- =============================================================================

-- 🔹 Ctrl+A: Выделить весь файл
map("n", "<C-a>", "ggVG", { desc = "Выделить весь файл" })
map("i", "<C-a>", "<Esc>ggVG<C-o>i", { desc = "Выделить весь файл и вернуться в Insert" })


-- 🔹 Ctrl+C: Копировать (в визуальном режиме)
map("v", "<C-c>", '"+y', { desc = "Копировать в системный буфер" })

-- 🔹 Ctrl+V: Вставить
map("n", "<C-v>", '"+p', { desc = "Вставить из системного буфера" })
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
-- map("n", "<C-s>", "<cmd>w<cr>", { desc = "Сохранить файл" })
-- map("i", "<C-s>", "<cmd>w<cr>", { desc = "Сохранить файл" })

-- 🔹 Ctrl+S: сохранить (если терминал перехватывает ^S, используй ^S-s)
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Сохранить файл" })
map("i", "<C-s>", "<C-o><cmd>w<cr>", { desc = "Сохранить файл" })

-- 🔹 Ctrl+F: Поиск (открывает fzf)
map("n", "<C-f>", "<cmd>FzfLua files<cr>", { desc = "Поиск файлов" })

-- 🔹 Ctrl+H: Заменить (открывает fzf live_grep)
map("n", "<C-g>", "<cmd>FzfLua live_grep<cr>", { desc = "Поиск по тексту" })

map("n", "<leader>sm", function()
    vim.notify([[
mini.ai:       yaf/cif/daf

mini.move:     Alt+j/k/l/h
mini.pairs:    () [] {} "" '' `` auto
mini.surround: sa(add) sd(delete) sr(replace)
mini.comment:  gcc  gc(visual)
    ]], vim.log.levels.INFO, { title = "Mini Plugins Help" })
end, { desc = "Mini plugins help" })

map("n", "<leader>h", function()
    vim.notify([[
  N A V I G A T I O N
  ────────────────────
  s → Flash jump (слово)
  S → Flash treesitter
  <C-f> → Файлы
  <C-g> → Grep
  <Tab> → Буферы
  <C-hjkl> → Сплиты
  ]d/[d → Ошибки
  gd → Определение
  Alt+hjkl → Двигать строки

  E D I T I N G
  ────────────────────
  <C-d/u> → Дублировать
  <leader>ca → Code action
  gcc → Комментировать
  sa/sd/sr → Surround
  yaf → Yank функцию
    ]], vim.log.levels.INFO, { title = "⌨ Help" })
end, { desc = "Help" })

-- В keymaps.lua
map("i", "<End>", "<C-o>$", { desc = "End of line" })
map("i", "<C-End>", "<C-o>$", { desc = "End of line" })
map("n", "<End>", "$", { desc = "End of line" })
map("v", "<End>", "$", { desc = "End of line" })

-- =============================================================================
-- INSERT MODE: полезные хоткеи, не выходя из режима вставки
-- =============================================================================


-- 🧭 Навигация
vim.keymap.set("i", "<C-h>", "<Left>", opts)
vim.keymap.set("i", "<C-l>", "<Right>", opts)
vim.keymap.set("i", "<C-k>", "<Up>", opts)
vim.keymap.set("i", "<C-j>", "<Down>", opts)

vim.keymap.set("i", "<C-Left>", "<C-o>b", opts)   -- слово назад
vim.keymap.set("i", "<C-Right>", "<C-o>w", opts)  -- слово вперёд
vim.keymap.set("i", "<C-a>", "<Home>", opts)      -- начало строки
vim.keymap.set("i", "<C-e>", "<End>", opts)       -- конец строки

-- 🗑️ Удаление
vim.keymap.set("i", "<C-BS>", "<C-o>db", opts)    -- удалить слово назад
vim.keymap.set("i", "<C-Del>", "<C-o>dw", opts)   -- удалить слово вперёд
vim.keymap.set("i", "<C-u>", "<C-o>0d$", opts)    -- удалить до начала строки

-- 📋 Копирование/вставка
vim.keymap.set("i", "<C-v>", "<C-r>+", { desc = "Paste from system clipboard" })


-- ⚡ Гибридные: одна команда Normal, не выходя из Insert
vim.keymap.set("i", "<C-x><C-o>", "<C-o>.", { desc = "Repeat last change" })
vim.keymap.set("i", "<C-x><C-f>", "<C-o>gf", { desc = "Open file under cursor" }) -- открыть файл под курсором
