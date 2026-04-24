-- =============================================================================
-- ~/.config/nvim/lua/plugins/specs/lsp.lua
-- LSP + Mason + blink.cmp — Go-focused, Neovim 0.12+
-- =============================================================================

return {
  -- ====================== MASON ======================
  {
    "mason-org/mason.nvim",
    cmd  = "Mason",
    opts = { ui = { border = "rounded" } },
    config = function(_, opts)
      require("mason").setup(opts)

      -- ✅ defer_fn: реестр успевает загрузиться после setup()
      vim.defer_fn(function()
        local registry = require("mason-registry")
        -- gopls ставим через mason для единообразия,
        -- но можно и через `go install golang.org/x/tools/gopls@latest`
        local tools = {
          "gopls",
          "goimports",   -- используется conform для форматирования
          "gofumpt",     -- используется conform для форматирования
          "golangci-lint",
          "lua-language-server",
          "stylua",
        }
        for _, name in ipairs(tools) do
          local ok, pkg = pcall(registry.get_package, name)
          if ok and not pkg:is_installed() then
            pkg:install()
          end
        end
      end, 500)
    end,
  },

  -- ====================== NVIM-LINT ======================
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        go = { "golangci-lint" },
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
    -- ✅ friendly-snippets убран: используем только свои Go-сниппеты (см. ниже)
    opts = {
      keymap     = { preset = "super-tab" },
      appearance = { nerd_font_variant = "mono" },

      sources = {
        -- ✅ path нужен: дополнение путей к файлам при import и os.Open
        default = { "lsp", "snippets", "path" },
      },

      snippets = {
        -- ✅ Встроенный движок сниппетов blink читает VSCode-формат из runtimepath.
        -- Наши сниппеты лежат в ~/.config/nvim/snippets/go.json (см. отдельный файл)
        preset = "default",
      },

      completion = {
        trigger    = { show_on_trigger_character = true },
        ghost_text = { enabled = true },
        list       = { selection = { preselect = false, auto_insert = false } },
        menu       = { border = "rounded" },
        accept     = { auto_brackets = { enabled = false } },
        documentation = {
          auto_show          = true,
          auto_show_delay_ms = 150,
          window = { border = "rounded", max_width = 80, max_height = 20 },
        },
      },

      signature = { enabled = true, window = { border = "rounded" } },
      fuzzy     = { implementation = "prefer_rust" },
    },
  },

  -- ====================== LSP ======================
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
      -- Диагностика
      vim.diagnostic.config({
        virtual_text     = { prefix = "●", spacing = 2 },
        underline        = true,
        update_in_insert = false,
        severity_sort    = true,
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
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("blink.cmp").get_lsp_capabilities()

      -- ✅ Регистрируем конфиги
      vim.lsp.config("gopls", {
        capabilities = capabilities,
        root_dir = vim.fs.root(0, { "go.work", "go.mod", ".git" }),
            flags = {
        debounce_text_changes = 150,  -- ✅ добавить
    },
        settings = {
          gopls = {
            gofumpt        = true,
            staticcheck    = true,
            semanticTokens = true,
            analyses       = { unusedparams = true, shadow = true, nilness = true },
            hints = {
              assignVariableTypes    = true,
              compositeLiteralFields = true,
              constantValues         = true,
              parameterNames         = true,
            },
            directoryFilters = { "-.git", "-node_modules" }, -- ✅ не индексировать мусор
          },
        },
      })

      -- lua_ls — нужен для редактирования самого конфига nvim
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
            telemetry   = { enable = false },
          },
        },
      })

      -- ✅ Включаем серверы после регистрации конфигов
      vim.lsp.enable({ "gopls", "lua_ls" })

      -- keymaps + отключение LSP-форматирования
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(args)
          local bufnr  = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          -- Форматирование только через conform, не через LSP
          client.server_capabilities.documentFormattingProvider      = false
          client.server_capabilities.documentRangeFormattingProvider = false
          if client.server_capabilities.textDocumentSync then
            client.server_capabilities.textDocumentSync.willSave          = false
            client.server_capabilities.textDocumentSync.willSaveWaitUntil = false
          end

          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          map("gd",          vim.lsp.buf.definition,     "Goto Definition")
          map("gD",          vim.lsp.buf.declaration,    "Goto Declaration")
          map("K",           vim.lsp.buf.hover,          "Hover")
          -- УДАЛИ эти три:
          map("gi",  vim.lsp.buf.implementation, "Goto Implementation")  -- уже есть gri
          map("gr",  vim.lsp.buf.references,     "References")           -- уже есть grr
          map("gy",  vim.lsp.buf.type_definition,"Goto Type Definition") -- уже есть grt
          map("<leader>ca",  vim.lsp.buf.code_action,    "Code Action")
          map("<leader>rn",  vim.lsp.buf.rename,         "Rename")
          map("[d",          vim.diagnostic.goto_prev,   "Prev Diagnostic")
          map("]d",          vim.diagnostic.goto_next,   "Next Diagnostic")
          map("<leader>ih",  function()
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
