-- =============================================================================
-- 6. КАСТОМНЫЕ HIGHLIGHTS (Treesitter + LSP Semantic, eye-friendly)
-- Палитра: тёплый OneDark, сниженный контраст, меньше синего/красного
-- =============================================================================

local function apply_highlights()
    local hls = {
        -- 🌿 Treesitter Core
        ["@function"]             = { fg = "#7ab4d4" },          -- мягкий стальной синий
        ["@function.call"]        = { fg = "#5eadb8" },          -- приглушённый циан
        ["@function.method"]      = { fg = "#7ab4d4" },
        ["@type"]                 = { fg = "#d4af6e" },          -- тёплое золото, не жёлтое
        ["@type.builtin"]         = { fg = "#d4af6e", italic = true },
        ["@keyword"]              = { fg = "#b87cc4" },          -- сиреневый (не кислотный)
        ["@keyword.return"]       = { fg = "#b87cc4", bold = true },
        ["@string"]               = { fg = "#8baf72" },          -- оливково-зелёный
        ["@string.escape"]        = { fg = "#5eadb8" },
        ["@comment"]              = { fg = "#6b7280", italic = true }, -- чуть светлее, легче читать
        ["@variable"]             = { fg = "#c8868e" },          -- приглушённый розовый вместо красного
        ["@variable.builtin"]     = { fg = "#c8868e", italic = true },
        ["@variable.parameter"]   = { fg = "#c8868e" },
        ["@variable.member"]      = { fg = "#d4af6e" },
        ["@constant"]             = { fg = "#c8945a" },          -- тёплый янтарь
        ["@constant.builtin"]     = { fg = "#c8945a", bold = true },
        ["@operator"]             = { fg = "#7abfbf" },          -- нейтральный циан
        ["@punctuation.bracket"]  = { fg = "#9ba3af" },          -- немного теплее
        ["@punctuation.delimiter"]= { fg = "#9ba3af" },

        -- 🟦 LSP Semantic Tokens
        ["@lsp.type.namespace"]         = { fg = "#5eadb8",},
        ["@lsp.type.variable"]          = { fg = "#c8868e" },
        ["@lsp.typemod.variable.local"] = { fg = "#c8868e" },
        ["@lsp.typemod.variable.global"]= { fg = "#c8868e" },
        ["@lsp.type.parameter"]         = { fg = "#c8868e" },
        ["@lsp.type.property"]          = { fg = "#d4af6e" },
        ["@lsp.type.enumMember"]        = { fg = "#c8945a" },
        ["@lsp.type.interface"]         = { fg = "#d4af6e", italic = true },
        ["@lsp.type.typeParameter"]     = { fg = "#b87cc4" },
        ["@lsp.type.decorator"]         = { fg = "#b87cc4" },

        -- 🎨 UI / Editor — тёплый тёмный фон, меньше холода
        CursorLine   = { bg = "#2d3038" },          -- чуть теплее
        Visual       = { bg = "#3a3f4b" },
        Search       = { bg = "#3e4859", fg = "#adb4bf" },
        IncSearch    = { bg = "#d4af6e", fg = "#282c34", bold = true },
        FloatBorder  = { fg = "#4a5263" },
        NormalFloat  = { bg = "#282c34" },
        WinSeparator = { fg = "#3a3f4b" },
        LineNr       = { fg = "#4a5263" },
        CursorLineNr = { fg = "#9ba3af", bold = true },
        SignColumn   = { bg = "#282c34" },
        ColorColumn  = { bg = "#2d3038" },

        -- 🩺 Diagnostics — underline вместо undercurl (меньше шума)
        DiagnosticError = { fg = "#c8868e", underline = true, sp = "#c8868e" },
        DiagnosticWarn  = { fg = "#d4af6e", underline = true, sp = "#d4af6e" },
        DiagnosticInfo  = { fg = "#7ab4d4", underline = true, sp = "#7ab4d4" },
        DiagnosticHint  = { fg = "#5eadb8", underline = true, sp = "#5eadb8" },
        DiagnosticVirtualTextError = { fg = "#c8868e", bg = "#2c2a2e" },
        DiagnosticVirtualTextWarn  = { fg = "#d4af6e", bg = "#2e2d2a" },
        DiagnosticVirtualTextInfo  = { fg = "#7ab4d4", bg = "#2a2d31" },
        DiagnosticVirtualTextHint  = { fg = "#5eadb8", bg = "#2a2d30" },
    }

    for name, val in pairs(hls) do
        vim.api.nvim_set_hl(0, name, val)
    end
end

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("CustomHighlights", { clear = true }),
    pattern = "*",
    desc = "Re-apply custom treesitter + LSP highlights",
    callback = apply_highlights,
})

apply_highlights()
