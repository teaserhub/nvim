-- lua/config/keymaps.lua
local map = vim.keymap.set

-- ==================== Основные ====================

map("n", "<leader>e", ":Telescope file_browser<CR>", { desc = "File Browser (Telescope)" })
map("n", "<leader>z", ":ZenMode<CR>", { desc = "Zen Mode" })

-- выход
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
--vim.keymap.set("n", "<leader>wq", ":wq<CR>", { desc = "Save & Quit" })
--vim.keymap.set("n", "<leader>qq", ":qa!<CR>", { desc = "Quit All Force" })

-- ==================== Навигация между NvimTree и редактором ====================
map("n", "<C-h>", "<C-w>h", { desc = "Go Left (to NvimTree)" })
map("n", "<C-l>", "<C-w>l", { desc = "Go Right (to Editor)" })
map("n", "<C-k>", "<C-w>k", { desc = "Go Up" })
map("n", "<C-j>", "<C-w>j", { desc = "Go Down" })

-- Быстрое переключение фокуса между деревом и редактором
--map("n", "<leader>er", ":NvimTreeFocus<CR>", { desc = "Focus NvimTree" })

-- ==================== Вкладки и буферы ====================
--map("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Next Buffer" })
--map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
--map("n", "<leader>bd", ":bd<CR>", { desc = "Close Buffer" })
--map("n", "<leader>bp", ":BufferLinePick<CR>", { desc = "Pick Buffer" })

-- Удобное переключение между буферами (вкладками)
map("n", "<Tab>", ":bnext<CR>", { desc = "Next Buffer" })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous Buffer" })
map("n", "<leader>bd", ":bd<CR>", { desc = "Close Buffer" })
map("n", "<leader>bp", ":ls<CR>:b ", { desc = "List and switch buffer" })

-- ==================== QoL улучшения (как в VSCode) ====================
-- Дублирование строки
map("n", "<C-d>", ":t.<CR>", { desc = "Duplicate Line" })
map("v", "<C-d>", "y'>p", { desc = "Duplicate Selection" })

-- Перемещение строк вверх/вниз
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move Line Down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move Line Up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move Selection Down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move Selection Up" })

-- Сохранение в нормальном и вставочном режиме
map("n", "<C-s>", ":w<CR>", { desc = "Save" })
map("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save" })

-- Умное выделение
map("n", "<C-a>", "gg<S-v>G", { desc = "Select All" })

-- ==================== Буфер обмена (системный) ====================
-- Полная поддержка копирования/вставки между Neovim и системой
map("v", "<C-c>", '"+y', { desc = "Copy to System Clipboard" })
map("n", "<C-c>", '"+yy', { desc = "Copy Line to System Clipboard" })
map("n", "<C-v>", '"+p', { desc = "Paste from System Clipboard" })
map("i", "<C-v>", '<Esc>"+pa', { desc = "Paste from System Clipboard" })
map("v", "<C-v>", '"+p', { desc = "Paste from System Clipboard" })

-- ==================== Telescope ====================
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find Files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live Grep" })
map("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent Files" })
map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Buffers" })

-- ==================== Go и Debug ====================
map("n", "<leader>gt", ":GoTest<CR>", { desc = "Run Tests" })
map("n", "<leader>gc", ":GoCoverage<CR>", { desc = "Coverage" })
map("n", "<leader>gr", ":GoRun<CR>", { desc = "Go Run" })
map("n", "<leader>gb", ":GoBuild<CR>", { desc = "Go Build" })
map("n", "<leader>gd", ":GoDebug<CR>", { desc = "Start Debug" })

-- LSP
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })

-- Автодополнение и сниппеты
map("i", "<Tab>", function()
  if require("blink.cmp").is_visible() then
    require("blink.cmp").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", false)
  end
end, { desc = "Accept Completion" })

map("i", "<CR>", function()
  if require("blink.cmp").is_visible() then
    require("blink.cmp").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", false)
  end
end, { desc = "Accept Completion with Enter" })
