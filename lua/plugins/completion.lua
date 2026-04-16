return {
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "*",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },

    config = function()
      local luasnip = require("luasnip")

      -- загрузка сниппетов
      require("luasnip.loaders.from_vscode").lazy_load()

      require("blink.cmp").setup({

        -- 🔥 КЛЮЧЕВОЕ: поведение клавиш
        keymap = {
          preset = "none",

          ["<Tab>"] = {
            function(cmp)
              if cmp.is_visible() then
                return cmp.select_next()
              elseif luasnip.expand_or_jumpable() then
                return luasnip.expand_or_jump()
              end
            end,
            "fallback",
          },

          ["<S-Tab>"] = {
            function(cmp)
              if cmp.is_visible() then
                return cmp.select_prev()
              elseif luasnip.jumpable(-1) then
                return luasnip.jump(-1)
              end
            end,
            "fallback",
          },

          ["<CR>"] = {
            function(cmp)
              if cmp.is_visible() then
                return cmp.accept()
              end
            end,
            "fallback",
          },

          ["<C-Space>"] = { "show", "fallback" },
          ["<C-e>"] = { "hide", "fallback" },
        },

        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = "mono",
        },

        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },

        snippets = {
          expand = function(snippet)
            luasnip.lsp_expand(snippet)
          end,
        },

        completion = {
          menu = {
            border = "rounded",
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

        cmdline = { enabled = false },
      })
    end,
  },
}
