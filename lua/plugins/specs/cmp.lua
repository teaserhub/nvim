return {
    -- 1. Движок автодополнения
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",      -- LSP source
            "hrsh7th/cmp-buffer",        -- Буферные слова
            "hrsh7th/cmp-path",          -- Пути к файлам
            "L3MON4D3/LuaSnip",          -- Сниппеты
            "saadparwaiz1/cmp_luasnip",  -- Источник сниппетов
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" }, -- LSP (gopls)
                    { name = "luasnip" },  -- Сниппеты
                }, {
                    { name = "buffer" },   -- Слова из буфера
                    { name = "path" },     -- Пути
                }),
            })
        end,
    },

}
