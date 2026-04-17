local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.wrap = false
opt.termguicolors = true
opt.signcolumn = "yes"

opt.clipboard = "unnamedplus"
opt.scrolloff = 8
-- ✨ Подсветка скопированного текста (yank)
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

-- 🔧 Мелкие, но важные улучшения интерфейса
vim.opt.splitbelow = true -- новые сплиты открываются снизу
vim.opt.splitright = true -- новые вертикальные сплиты справа
vim.opt.updatetime = 300 -- быстрее обновление gitsigns, lsp, cursorhold
vim.opt.completeopt = "menuone,noinsert,noselect" -- улучшение меню cmp
vim.opt.wildmode = "longest:full,full" -- умное автодополнение в cmdline (:e, :bd и т.д.)
--opt.showtabline = 2
--vim.opt.hidden = true -- Оставляет буферы в памяти при переключении
