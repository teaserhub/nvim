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

-- ============================================
-- ЗАМЕНА WHICH-KEY: Просмотр всех маппингов по <Leader>?
-- ============================================
local function show_keymaps()
    local maps = vim.api.nvim_get_keymap("n") -- только normal mode
    local lines = {}

    for _, map in ipairs(maps) do
        local lhs = map.lhs
        local desc = map.desc or ""
        local rhs = map.rhs or ""

        -- Фильтруем мусор: убираем <Plug> маппинги и пустые
        if lhs:sub(1, 6) ~= "<Plug>" and lhs ~= "" then
            -- Форматируем красиво: "Space f f  →  Find Files"
            local display_lhs = lhs:gsub("<Leader>", "Space ")
            local display_desc = desc ~= "" and desc or rhs:gsub("<Cmd>", ""):gsub("<CR>", "")

            if display_desc ~= "" then
                table.insert(lines, string.format("%-20s → %s", display_lhs, display_desc))
            end
        end
    end

    -- Сортируем для читаемости
    table.sort(lines)

    -- Отправляем в fzf-lua (если он есть)
    local ok, fzf = pcall(require, "fzf-lua")
    if ok then
        fzf.fzf_exec(lines, {
            prompt = "🗺️  Keymaps (Normal Mode) > ",
            winopts = { height = 0.5, width = 0.6, row = 0.5, col = 0.5 },
            actions = {
                -- При нажатии Enter — выполняем команду (извлекаем оригинальный lhs)
                default = function(selected)
                    local lhs = selected[1]:match("^(%S+)"):gsub("Space ", "<Leader>")
                    vim.cmd("normal! " .. lhs)
                end
            }
        })
    else
        -- Fallback: если fzf-lua нет, просто выводим в буфер
        vim.cmd("new")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        vim.bo.buftype = "nofile"
        vim.bo.modifiable = false
    end
end

-- Вешаем на <Leader>?
vim.keymap.set("n", "<Leader>?", show_keymaps, { desc = "Show all keymaps" })

-- (Опционально) Можно повесить и на команду :Maps
vim.api.nvim_create_user_command("Maps", show_keymaps, {})
