-- lua/config/keymaps.lua
local map = vim.keymap.set

-- ==================== Основные ====================
map("n", "<leader>e", ":Telescope file_browser<CR>", { desc = "File Browser (Telescope)" })
--map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
--map("n", "<leader>er", ":Neotree focus<CR>", { desc = "Focus Neo-tree" })
-- Навигация между окнами
map("n", "<C-h>", "<C-w>h", { desc = "Go Left" })
map("n", "<C-l>", "<C-w>l", { desc = "Go Right" })
map("n", "<C-k>", "<C-w>k", { desc = "Go Up" })
map("n", "<C-j>", "<C-w>j", { desc = "Go Down" })

-- ==================== Telescope (основной способ работы с файлами) ====================
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find Files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live Grep" })
map("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent Files" })
map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Open Buffers" })

-- ==================== QoL ====================
map("n", "<C-s>", ":w<CR>", { desc = "Save" })
map("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save" })

map("n", "<C-a>", "gg<S-v>G", { desc = "Select All" })
map("v", "<C-c>", '"+y', { desc = "Copy to System" })
map("n", "<C-c>", '"+yy', { desc = "Copy Line to System" })
map("n", "<C-v>", '"+p', { desc = "Paste from System" })
map("i", "<C-v>", '<Esc>"+pa', { desc = "Paste" })

-- Комментарии
map("n", "<C-/>", "gcc", { desc = "Comment Line", remap = true })
map("v", "<C-/>", "gc", { desc = "Comment Selection", remap = true })

-- Дублирование строки
map("n", "<C-d>", ":t.<CR>", { desc = "Duplicate Line" })
