-- plugins/specs/flash.lua
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    -- Пул меток: home-row первыми → физически проще попасть
    labels = "asdfghjklqwertyuiopzxcvbnmASDFGHJKLQWERTYUIOPZXCVBNM",

    search = {
      -- forward=true + wrap=true = полный обход файла в обе стороны
      -- (flash идёт вперёд, доходит до конца, оборачивается и идёт до курсора)
      forward     = true,
      wrap        = true,   -- ❗ без wrap совпадения после конца/начала файла меток не получают
      multi_window = false,
      mode        = "exact",
      incremental = false,
    },

    jump = {
      jumplist   = true,
      pos        = "start",
      history    = false,
      register   = false,
      nohlsearch = false,
      autojump   = false,
    },

    label = {
      uppercase = true,

      -- ❗ ГЛАВНЫЙ FIX: distance=false
      -- При distance=true (дефолт) flash сначала раздаёт метки совпадениям
      -- БЛИЖАЙШИМ к курсору. Если меток (52-62) меньше чем совпадений —
      -- дальние вхождения просто остаются без метки.
      -- distance=false = равномерное распределение по всему файлу.
      distance = false,

      -- reuse="all" позволяет переиспользовать заглавные буквы тоже
      -- (дефолт "lowercase" делал верхний регистр одноразовым)
      reuse  = "all",

      after   = true,
      before  = false,
      style   = "overlay",
      current = true,
      min_pattern_length = 0,

      rainbow = {
        enabled = true,
        shade   = 5,
      },
    },

    highlight = {
      backdrop = true,
      matches  = true,
      priority = 5000,
    },

    modes = {
      search = {
        enabled = true,
      },
      char = {
        enabled    = true,
        multi_line = true,
        keys       = { "f", "F", "t", "T" },
        search     = { wrap = false },
        label      = { exclude = "hjkliardc" },
      },
      treesitter = {
        enabled = true,
        labels  = "asdfghjklqwertyuiopzxcvbnm",
      },
    },
  },

  keys = {
    { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "r",     mode = "o",               function() require("flash").remote() end,             desc = "Flash Remote" },
    { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Flash Treesitter Search" },
    -- переключение меток прямо во время поиска через /
    { "<C-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
  },
}
