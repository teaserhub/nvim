-- =============================================================================
-- LSP + Mason + blink.cmp + nvim-lint
-- Neovim 0.12+
-- =============================================================================

return {
  -- ====================== MASON ======================
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = { ui = { border = "rounded" } },
    config = function(_, opts)
      require("mason").setup(opts)

      -- Автоустановка только для JS/Web тулзов
      -- Go-инструменты ставь через go install (быстрее и надёжнее)
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonUpdateCompleted",
        callback = function()
          local registry = require("mason-registry")
          local tools = {
            "typescript-language-server",
            "html-lsp",
            "css-lsp",
            "lua-language-server",
            "stylua",
            "prettier",
            "eslint_d",
          }
          for _, tool in ipairs(tools) do
            local ok, pkg = pcall(registry.get_package, tool)
            if ok and not pkg:is_installed() then
              pkg:install()
            end
          end
        end,
      })
    end,
  },

  -- ====================== NVIM-LINT ======================
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        go              = { "golangcilint" },
        javascript      = { "eslint_d" },
        typescript      = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function()
          if vim.bo.buflisted and vim.api.nvim_buf_line_count(0) <= 10000 then
            pcall(lint.try_lint)
          end
        end,
      })
    end,
  },

  -- ====================== BLINK.CMP ======================
  {
    "saghen/blink.cmp",
    version      = "1.*",
    event        = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = function()
      local function not_in_string()
        local ok, node = pcall(vim.treesitter.get_node, { ignore_injections = true })
        if not ok or not node then return true end
        local t = node:type()
        return not (t:match("string") or t:match("comment") or
        t == "jsx_attribute_value" or t == "template_string")
      end

      return {
        keymap     = { preset = "super-tab" },
        appearance = { nerd_font_variant = "mono" },
        sources    = {
          default   = { "lsp", "path", "snippets", "buffer" },
          providers = {
            lsp      = { enabled = function() return not_in_string() end },
            snippets = { enabled = function() return not_in_string() end },
            buffer   = { enabled = function() return not_in_string() end },
          },
        },
        completion = {
          trigger    = { show_on_trigger_character = true },
          ghost_text = { enabled = true },
          list       = { selection = { preselect = false, auto_insert = false } },
          menu       = { border = "rounded" },
          accept     = { auto_brackets = { enabled = false } },
          documentation = {
            auto_show          = true,
            auto_show_delay_ms = 200,
            window             = { border = "rounded" },
          },
        },
        signature = { enabled = true, window = { border = "rounded" } },
        fuzzy     = { implementation = "prefer_rust" },
      }
    end,
  },

  -- ====================== LSP CONFIG ======================
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
      -- Диагностика
      vim.diagnostic.config({
        virtual_text   = { prefix = "●", spacing = 2 },
        underline      = true,
        update_in_insert = false,
        severity_sort  = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚",
            [vim.diagnostic.severity.WARN]  = "󰀪",
            [vim.diagnostic.severity.INFO]  = "󰌵",
            [vim.diagnostic.severity.HINT]  = "󰌶",
          },
        },
        float = { border = "rounded", source = true, header = "", prefix = "" },
      })

      vim.filetype.add({ extension = { gowork = "gowork", gotmpl = "gotmpl" } })

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- ✅ Сначала регистрируем все конфиги через vim.lsp.config(),
      -- потом одним вызовом vim.lsp.enable() активируем их.
      -- Это гарантирует что capabilities и settings применяются до
      -- того как сервер поднимется при открытии файла.
      local servers = {
        gopls = {
          capabilities = capabilities,
          settings = {
            gopls = {
              gofumpt      = true,
              staticcheck  = true,
              semanticTokens = true,
              analyses     = { unusedparams = true, shadow = true, nilness = true },
              hints = {
                assignVariableTypes    = true,
                compositeLiteralFields = true,
                constantValues         = true,
                parameterNames         = true,
              },
            },
          },
        },
        ts_ls = { capabilities = capabilities, single_file_support = true },
        html  = { capabilities = capabilities },
        cssls = { capabilities = capabilities },
        lua_ls = {
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace   = { checkThirdParty = false },
              telemetry   = { enable = false },
            },
          },
        },
      }

      -- ✅ Шаг 1: регистрируем конфиги
      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
      end

      -- ✅ Шаг 2: включаем серверы (после регистрации конфигов)
      vim.lsp.enable(vim.tbl_keys(servers))

      -- ✅ Шаг 3: keymaps и отключение LSP-форматирования через LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(args)
          local bufnr  = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          -- Блокируем LSP-форматирование — форматируем только через conform
          client.server_capabilities.documentFormattingProvider      = false
          client.server_capabilities.documentRangeFormattingProvider = false
          if client.server_capabilities.textDocumentSync then
            client.server_capabilities.textDocumentSync.willSave          = false
            client.server_capabilities.textDocumentSync.willSaveWaitUntil = false
          end

          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs,
            { buffer = bufnr, silent = true, desc = desc })
          end

          map("n", "gd",         vim.lsp.buf.definition,     "Goto Definition")
          map("n", "gD",         vim.lsp.buf.declaration,    "Goto Declaration")
          map("n", "K",          vim.lsp.buf.hover,          "Hover")
          map("n", "gi",         vim.lsp.buf.implementation, "Goto Implementation")
          map("n", "gr",         vim.lsp.buf.references,     "References")
          map("n", "gy",         vim.lsp.buf.type_definition,"Goto Type Definition")
          map("n", "<leader>ca", vim.lsp.buf.code_action,    "Code Action")
          map("n", "<leader>rn", vim.lsp.buf.rename,         "Rename")
          map("n", "[d",         vim.diagnostic.goto_prev,   "Prev Diagnostic")
          map("n", "]d",         vim.diagnostic.goto_next,   "Next Diagnostic")
          map("n", "<leader>ih", function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
              { bufnr = bufnr }
            )
          end, "Toggle Inlay Hints")
        end,
      })
    end,
  },
}
