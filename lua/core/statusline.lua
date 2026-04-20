-- ============================================
-- STATUSLINE + WINBAR (Git + LSP Диагностика)
-- ============================================

-- ---------- ФУНКЦИИ ДЛЯ STATUSLINE ----------
function _G.git_branch()
  if vim.fn.exists("*FugitiveHead") == 1 then
    local head = vim.fn.FugitiveHead()
    if head ~= "" then
      return "  " .. head
    end
  end
  return ""
end

function _G.lsp_diagnostics()
  local count = {
    errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }),
    warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }),
    hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }),
  }
  
  local parts = {}
  if count.errors > 0 then
    table.insert(parts, "%#DiagnosticError#E:" .. count.errors)
  end
  if count.warnings > 0 then
    table.insert(parts, "%#DiagnosticWarn#W:" .. count.warnings)
  end
  if count.hints > 0 then
    table.insert(parts, "%#DiagnosticHint#H:" .. count.hints)
  end
  
  if #parts > 0 then
    return " " .. table.concat(parts, " ") .. " "
  end
  return ""
end

-- ---------- ФУНКЦИИ ДЛЯ WINBAR ----------
function _G.winbar_path()
  local file = vim.fn.expand("%:.")
  if file == "" then
    return " [No Name]"
  end
  
  local root = vim.fn.getcwd()
  local full_path = vim.fn.expand("%:p")
  
  if full_path:sub(1, #root) == root then
    return " " .. full_path:sub(#root + 2)
  else
    return " " .. file
  end
end

function _G.git_blame()
  if vim.fn.exists("*FugitiveBlame") == 1 then
    local blame = vim.fn.FugitiveBlame()
    if blame ~= "" then
      return "  " .. blame:sub(1, 40)
    end
  end
  return ""
end

-- ---------- НАСТРОЙКА STATUSLINE (НИЗ) ----------
vim.opt.laststatus = 2

vim.opt.statusline = table.concat({
  " %f",                     -- имя файла
  "%m",                      -- [+] изменён
  "%r",                      -- [RO] только чтение
  "%{v:lua.git_branch()}",  -- Git ветка
  "%=%{v:lua.lsp_diagnostics()}", -- Ошибки LSP справа
  " %l,%c  ",                -- строка,колонка
}, "")

-- ---------- НАСТРОЙКА WINBAR (ВЕРХ) ----------
vim.opt.winbar = table.concat({
  "%{%v:lua.winbar_path()%}",
  "%m",
  "%{v:lua.git_blame()%}",
}, "")

-- Показывать winbar только в активном окне (опционально)
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "WinLeave" }, {
  callback = function()
    local active = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if win == active then
        vim.wo[win].winbar = "%{%v:lua.winbar_path()%}%m%{v:lua.git_blame()%}"
      else
        vim.wo[win].winbar = nil
      end
    end
  end,
})

-- ---------- ЦВЕТА ДИАГНОСТИКИ ----------
vim.cmd([[
  highlight DiagnosticError guifg=#e06c75
  highlight DiagnosticWarn  guifg=#e5c07b
  highlight DiagnosticHint  guifg=#61afef
]])
