-- lua/plugins/completion.lua
return {
  "saghen/blink.cmp",
  lazy = false,
  version = "1.*",   -- стабильные бинарники, не "*"
  dependencies = { "rafamadriz/friendly-snippets" },

  config = function()
    require("blink.cmp").setup({

      keymap = { preset = "super-tab" },

      appearance = {
        -- use_nvim_cmp_as_default устарело и будет удалено — убираем
        nerd_font_variant = "mono",
      },

sources = {
  default = { "lsp", "path", "snippets", "buffer" },
  providers = {
    snippets = {
      score_offset = -1,
      -- не показывать сниппеты внутри строк
      should_show_items = function()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local line = vim.api.nvim_get_current_line()
        local before = line:sub(1, col)
        -- если курсор внутри кавычек — скрыть сниппеты
        local _, sq = before:gsub("'", "")
        local _, dq = before:gsub('"', "")
        return sq % 2 == 0 and dq % 2 == 0
      end,
    },
    buffer = {
      min_keyword_length = 4,
      max_items = 5,
    },
  },
},

      fuzzy = {
        -- use_typo_resistance / use_frecency / use_proximity убраны
        -- в v1.x правильный ключ:
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
            auto_insert = false,   -- не вставлять до явного подтверждения
          },
        },

        accept = {
          create_undo_point = true,
          auto_brackets = { enabled = true },
        },

        menu = {
          border = "rounded",
          draw = {
            treesitter = { "lsp" },   -- подсветка синтаксиса в меню
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
