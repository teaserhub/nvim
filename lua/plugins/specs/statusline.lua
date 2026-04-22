return {
  "echasnovski/mini.statusline",
  version = "*",
  event = "VeryLazy",
  opts = function()
    return {
      content = {
        active = function()
          local m = vim.fn.mode()

          -- ✅ FIX: v и V разные режимы
          local mode_map = {
            n  = "N",  i  = "I",  v  = "V",
            V  = "VL", ["\22"] = "VB",  -- visual-block
            c  = "C",  R  = "R",  t  = "T",
            s  = "S",  S  = "SL",
          }
          local mode    = mode_map[m] or m:upper()
          local mode_hl = m == "n" and "%#ModeNormal#"
                       or m == "i" and "%#ModeInsert#"
                       or (m == "v" or m == "V" or m == "\22") and "%#ModeVisual#"
                       or "%#ModeOther#"

          -- Git ветка
          local git    = vim.b.gitsigns_status_dict
          local branch = (git and git.head and git.head ~= "")
                         and (" 󰊢 " .. git.head .. " ")
                         or ""

          -- Файл + флаги
          local file  = vim.fn.expand("%:t")
          local flags = (vim.bo.readonly  and " 󰌾" or "")
                     .. (vim.bo.modified  and " ●" or "")
          file = (file ~= "" and file or "[No Name]") .. flags

          -- Тип файла (опытные всегда видят)
          local ft = vim.bo.filetype ~= "" and ("  " .. vim.bo.filetype) or ""

          -- ✅ Активный LSP-сервер
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          local lsp = ""
          if #clients > 0 then
            -- показываем первый значимый (не null-ls / conform)
            for _, c in ipairs(clients) do
              if c.name ~= "null-ls" and c.name ~= "conform" then
                lsp = "  " .. c.name
                break
              end
            end
          end

          -- Диагностика
          local d    = vim.diagnostic.count(0)
          local err  = d[vim.diagnostic.severity.ERROR] or 0
          local warn = d[vim.diagnostic.severity.WARN]  or 0
          local diag = ""
          if err  > 0 then diag = diag .. " %#DiagErr#󰅚 " .. err  .. "%#StatusLine#" end
          if warn > 0 then diag = diag .. " %#DiagWarn#󰀪 " .. warn .. "%#StatusLine#" end

          -- Позиция
          local line = vim.fn.line(".")
          local col  = vim.fn.virtcol(".")
          local pct  = math.floor(line / math.max(vim.fn.line("$"), 1) * 100)
          local pos  = string.format("%d:%d  %d%%%%", line, col, pct)

          return table.concat({
            mode_hl, " ", mode, " ",
            "%#StatusLine#",
            branch, file, diag,
            ft, lsp,
            "%=",                          -- правая часть
            "%#StatusLinePos# ", pos, " ",
          })
        end,

        inactive = function()
          return "%#StatusLineNC# " .. (vim.fn.expand("%:t") ~= "" and vim.fn.expand("%:t") or "[No Name]")
        end,
      },
      set_vim_settings = false,
    }
  end,

  config = function(_, opts)
    require("mini.statusline").setup(opts)

    local function set_hls()
      local h = vim.api.nvim_set_hl
      -- ✅ Явно указываем bg = "NONE" для всех групп
      h(0, "StatusLine",   { fg = "#cdd6f4", bg = "NONE" })
      h(0, "StatusLineNC", { fg = "#5c6370", bg = "NONE" })
      h(0, "ModeNormal",   { fg = "#c678dd", bg = "NONE", bold = true })
      h(0, "ModeInsert",   { fg = "#98c379", bg = "NONE", bold = true })
      h(0, "ModeVisual",   { fg = "#e5c07b", bg = "NONE", bold = true })
      h(0, "ModeOther",    { fg = "#56b6c2", bg = "NONE" })
      h(0, "StatusLinePos",{ fg = "#56b6c2", bg = "NONE" })
      h(0, "DiagErr",      { fg = "#e06c75", bg = "NONE" })
      h(0, "DiagWarn",     { fg = "#e5c07b", bg = "NONE" })
    end

    -- ✅ FIX: highlights переприменяются при смене темы
    set_hls()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group    = vim.api.nvim_create_augroup("MiniStatuslineHl", { clear = true }),
      pattern  = "*",
      callback = set_hls,
    })

    vim.o.laststatus = 2
    vim.o.showmode   = false
  end,
}
