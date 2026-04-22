-- core/keymaps.lua
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "

-- Выход из insert через jj
map("i", "jj", "<Esc>", opts)

-- Сохранение / Выход
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- Буферы
map("n", "<leader>l", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>h", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>bD", function()
  local cur = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= cur and vim.bo[buf].buflisted then
      pcall(vim.cmd, "bd " .. buf)
    end
  end
end, { desc = "Close all except current" })
map("n", "<leader>bo", "<cmd>only<CR>", { desc = "Close other splits" })

-- Навигация по сплитам
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Дублирование строк
map("n", "<A-j>", ":t.<CR>", { desc = "Duplicate line down" })
map("n", "<A-k>", ":t.-2<CR>", { desc = "Duplicate line up" })
map("v", "<A-j>", ":m'>+1<CR>gv=gv", { desc = "Duplicate selection down" })
map("v", "<A-k>", ":m'<-2<CR>gv=gv", { desc = "Duplicate selection up" })

-- Очистка подсветки поиска
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search" })

-- VS Code style (Ctrl+C/V/X/Z/Y/S/F/H)
map("v", "<C-c>", '"+y', { desc = "Copy to system clipboard" })
map("n", "<C-v>", '"+p', { desc = "Paste from system clipboard" })
map("i", "<C-v>", '<C-r>+', { desc = "Paste in insert" })
map("v", "<C-v>", '"+p', { desc = "Paste and replace" })
map("v", "<C-x>", '"+x', { desc = "Cut to system clipboard" })
map("n", "<C-z>", "u", { desc = "Undo" })
map("i", "<C-z>", "<C-o>u", { desc = "Undo" })
map("n", "<C-y>", "<C-r>", { desc = "Redo" })
map("i", "<C-y>", "<C-o><C-r>", { desc = "Redo" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save" })
map("i", "<C-s>", "<C-o><cmd>w<CR>", { desc = "Save" })
map("n", "<C-f>", "<cmd>FzfLua files<CR>", { desc = "Find files" })
map("n", "<C-h>", "<cmd>FzfLua live_grep<CR>", { desc = "Live grep" })

-- Просмотр маппингов
local function show_keymaps()
  local maps = vim.api.nvim_get_keymap("n")
  local lines = {}
  for _, m in ipairs(maps) do
    local lhs = m.lhs
    local desc = m.desc or ""
    local rhs = m.rhs or ""
    if lhs:sub(1, 6) ~= "<Plug>" and lhs ~= "" then
      local display_lhs = lhs:gsub("<Leader>", "<Space>")
      local display_desc = desc ~= "" and desc or rhs:gsub("<Cmd>", ""):gsub("<CR>", "")
      if display_desc ~= "" then
        table.insert(lines, string.format("%-20s → %s", display_lhs, display_desc))
      end
    end
  end
  table.sort(lines)
  local ok, fzf = pcall(require, "fzf-lua")
  if ok then
    fzf.fzf_exec(lines, {
      prompt = "🗺️ Keymaps (Normal) > ",
      winopts = { height = 0.5, width = 0.6, row = 0.5, col = 0.5 },
      actions = {
        ["default"] = function(selected)
          local lhs = selected[1]:match("^(%S+)"):gsub("<Space>", "<Leader>")
          vim.cmd("normal! " .. lhs)
        end
      }
    })
  else
    vim.cmd("new")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.bo.buftype = "nofile"
    vim.bo.modifiable = false
  end
end
map("n", "?", show_keymaps, { desc = "Show keymaps" })
vim.api.nvim_create_user_command("Maps", show_keymaps, {})
