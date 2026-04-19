return {

  -- ================= MASON =================
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    event = "VeryLazy",
    config = function()
      require("mason").setup({
        ui = { border = "rounded" },
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "gopls",
        "ts_ls",
        "html",
        "cssls",
      },
      automatic_installation = true,
    },
  },

  -- ================= BLINK.CMP =================
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = { preset = "super-tab" },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
        ghost_text = { enabled = false },        -- выключен, чтобы не мешал
        list = {
          selection = { preselect = false, auto_insert = false },
        },
      },

      signature = { enabled = true },

      fuzzy = { implementation = "lua" },       -- стабильная версия
    },
  },

  -- ================= LSP =================
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

      vim.lsp.config("*", { capabilities = capabilities })

      -- Автокоманды для клавиш
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "gr", vim.lsp.buf.references, "References")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
          map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
          map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
        end,
      })

      -- Серверы
      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            usePlaceholders = false,     -- важно!
          },
        },
      })

      vim.lsp.config("ts_ls", {})
      vim.lsp.config("html", {})
      vim.lsp.config("cssls", {})

      vim.lsp.enable({ "gopls", "ts_ls", "html", "cssls" })
    end,
  },
}
