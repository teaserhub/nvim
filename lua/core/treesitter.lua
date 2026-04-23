-- ~/.config/nvim/lua/core/treesitter.lua
-- Neovim 0.12 встроенный treesitter (минимальный)

-- =============================================================================
-- 1. ПАРСЕРЫ
-- =============================================================================
local parsers = {
    "go",
    "gomod",
    "gowork",
    "gosum",
    "lua",
    "luadoc",
    "javascript",
    "typescript",
    "tsx",
    "html",
    "css",
    "scss",
    "json",
    "markdown",
    "markdown_inline",
    "vim",
    "vimdoc",
    "query",
    "regex",
    "bash",
}

-- Установить парсеры при запуске
for _, parser in ipairs(parsers) do
    pcall(vim.treesitter.require_language, parser)
end

-- =============================================================================
-- 2. FOLDING
-- =============================================================================
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldlevel = 99
vim.wo.foldenable = true
