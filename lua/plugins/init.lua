-- lua/plugins/init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    require("plugins.theme"),
    require("plugins.vscode"),
    require("plugins.treesitter"),
    require("plugins.completion"), 
    require("plugins.lsp"),
    require("plugins.go"),
    require("plugins.formatter"),
    --  require("plugins.bufferline"), -- ← НОВОЕ: вкладки как в VSCode
    require("plugins.telescope"),
    -- require("plugins.noice"),
--    require("config.terminal"),
    require("plugins.statusline"),
    require("plugins.git"),
    require("plugins.trouble"),
    require("plugins.comment"),
    require("plugins.dap"),      -- отладка
    require("plugins.linter"),   -- golangci-lint
    --    require("plugins.ai"),     -- Codeium AI
    require("plugins.terminal"), -- ToggleTerm
    require("plugins.emmet"),    -- Emmet
    require("plugins.whichkey"),
    require("plugins.dashboard"),
    require("plugins.zenmode"),
    require("plugins.session"),
    require("plugins.qol"),
    require("plugins.filebrowser"),
    require("plugins.fzf"),
})
