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
  -- MINI.INDENTSCOPE
  -- ═══════════════════════════════════════════════
  {
    "echasnovski/mini.indentscope",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      symbol = "┊",
      options = { try_as_border = true },
      draw = {
        delay = 50,
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
      skip_ts = { "string", "comment" },
      skip_ft = { "gitcommit", "help", "log" },
      skip_unbalanced = true,
      mappings = {
        ["`"] = { action = "open", pair = "``", neigh_pattern = "[^\\]`" },
      },
    },
  },

  -- ═══════════════════════════════════════════════
  -- MINI.SURROUND
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
}
