-- lua/plugins/completion.lua
return {
  "saghen/blink.cmp",
  lazy = false,
  version = "1.*",
  dependencies = { "rafamadriz/friendly-snippets" },

  config = function()
    require("blink.cmp").setup({

      keymap = { preset = "super-tab" },

      appearance = {
        nerd_font_variant = "mono",
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },

        -- глобальный фильтр: ничего не показывать в комментариях
        transform_items = function(_, items)
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local before = vim.api.nvim_get_current_line():sub(1, col)
          local in_comment = (
            before:match("^%s*%-%-") or -- Lua
            before:match("^%s*//")  or -- Go, JS, TS, C
            before:match("^%s*#")      -- Python, Ruby, Shell
          )
          if in_comment then return {} end
          return items
        end,

        providers = {
          lsp = {
            -- LSP не показывать в комментариях (доп. защита)
            should_show_items = function()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before = vim.api.nvim_get_current_line():sub(1, col)
              return not (
                before:match("^%s*%-%-") or
                before:match("^%s*//")  or
                before:match("^%s*#")
              )
            end,
          },

          snippets = {
            score_offset = -1,
            -- сниппеты не показывать внутри строк
            should_show_items = function()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before = vim.api.nvim_get_current_line():sub(1, col)
              local _, dq = before:gsub('"', "")
              local _, sq = before:gsub("'", "")
              local _, bq = before:gsub("`", "")
              return dq % 2 == 0 and sq % 2 == 0 and bq % 2 == 0
            end,
          },

          buffer = {
            min_keyword_length = 4,
            max_items = 5,
            -- buffer не показывать внутри строк и комментариев
            should_show_items = function()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local line = vim.api.nvim_get_current_line()
              local before = line:sub(1, col)
              if
                before:match("^%s*%-%-") or
                before:match("^%s*//")  or
                before:match("^%s*#")
              then
                return false
              end
              local _, dq = before:gsub('"', "")
              local _, sq = before:gsub("'", "")
              local _, bq = before:gsub("`", "")
              return dq % 2 == 0 and sq % 2 == 0 and bq % 2 == 0
            end,
          },

          path = {
            -- path только когда реально пишешь путь
            should_show_items = function()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before = vim.api.nvim_get_current_line():sub(1, col)
              return before:match('["\'`]%.?/') ~= nil
            end,
          },
        },
      },

      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },

      completion = {
        keyword = { range = "prefix" },

        trigger = {
          prefetch_on_insert = true,
          show_on_backspace_in_keyword = true,
        },

        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },

        accept = {
          create_undo_point = true,
          auto_brackets = { enabled = true },
        },

        menu = {
          border = "rounded",
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
            },
          },
        },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "rounded" },
        },

        ghost_text = { enabled = true },
      },

      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
    })
  end,
}
