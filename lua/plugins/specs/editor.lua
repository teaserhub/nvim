-- plugins/specs/editor.lua
local disabled_ft = {
  "oil",
  "help",
  "lazy",
  "mason",
  "fzf",
  "Trouble",
  "dashboard",
  "terminal",
}

return {
  -- ═══════════════════════════════════════════════
  -- INDENTS: ibl + scope separation
  -- ═══════════════════════════════════════════════
  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   event = { "BufReadPost", "BufNewFile" },
  --   main = "ibl",
  --   opts = {
  --     indent = { char = "┊", tab_char = "┊" },
  --     scope = { enabled = false },
  --
  --     exclude = {
  --       filetypes = disabled_ft,
  --       buftypes = { "terminal", "nofile" },
  --     },
  --   },
  -- },

  {
    "echasnovski/mini.indentscope",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      symbol = "┊",
      options = { try_as_border = true },

      draw = {
        delay = 50, -- ❗ FIX: убран 0 → меньше redraw jitter
      },
    },

    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = disabled_ft,
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- ═══════════════════════════════════════════════
  -- MINI.PAIRS
  -- ═══════════════════════════════════════════════
  {
    "echasnovski/mini.pairs",
    version = "*",
    event = "InsertEnter",

    opts = {
      modes = { insert = true, command = true, terminal = false },

      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
skip_ts         = { "string", "comment" }, -- ✅ вернуть
      -- ❗ FIX: убрали markdown из skip_ft
      skip_ft = { "gitcommit", "help", "log" },

      skip_unbalanced = true,

      mappings = {
        ["`"] = { action = "open", pair = "``", neigh_pattern = "[^\\]`" },
      },
    },
  },

  -- ═══════════════════════════════════════════════
  -- SURROUND
  -- ═══════════════════════════════════════════════
  {
    "echasnovski/mini.surround",
    version = "*",

    keys = {
      { "sa", mode = { "n", "v" }, desc = "Surround add" },
      { "sd", mode = { "n", "v" }, desc = "Surround delete" },
      { "sr", mode = { "n", "v" }, desc = "Surround replace" },
      { "sf", desc = "Surround find" },
      { "sF", desc = "Surround find left" },
      { "sh", desc = "Surround highlight" },
      { "sn", desc = "Surround update n_lines" },
    },

    opts = {
      mappings = {
        add = "sa",
        delete = "sd",
        replace = "sr",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        update_n_lines = "sn",
      },
      n_lines = 50,
    },
  },

  -- ═══════════════════════════════════════════════
  -- MINI.AI
  -- ═══════════════════════════════════════════════
  {
    "echasnovski/mini.ai",
    version = "*",

    -- ❗ FIX: вместо VeryLazy → keys (правильный lazy)
    keys = {
      { "a", mode = { "x", "o" } },
      { "i", mode = { "x", "o" } },
    },

    opts = {
      n_lines = 500,
    },
  },

  -- ═══════════════════════════════════════════════
  -- MINI.MOVE
  -- ═══════════════════════════════════════════════
  {
    "echasnovski/mini.move",
    version = "*",

    -- ❗ FIX: keys вместо VeryLazy
keys = {
    { "<M-h>", mode = { "n", "v" } },
    { "<M-j>", mode = { "n", "v" } },
    { "<M-k>", mode = { "n", "v" } },
    { "<M-l>", mode = { "n", "v" } },
},

    opts = {
      mappings = {
        left = "<M-h>",
        right = "<M-l>",
        down = "<M-j>",
        up = "<M-k>",

        line_left = "<M-h>",
        line_right = "<M-l>",
        line_down = "<M-j>",
        line_up = "<M-k>",
      },
    },
  },

  -- ═══════════════════════════════════════════════
  -- SPLITJOIN
  -- ═══════════════════════════════════════════════
  {
    "echasnovski/mini.splitjoin",
    version = "*",

    keys = {
      { "gS", desc = "Split structure" },
      { "gJ", desc = "Join structure" },
    },

    opts = {
      mappings = {
        toggle = "",
        split = "gS",
        join = "gJ",
      },
    },
  },
}
