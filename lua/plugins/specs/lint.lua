return {
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufWritePost" },
        config = function()
            local lint = require("lint")
            
            -- Линтеры для языков
            lint.linters_by_ft = {
                -- go = { "staticcheck" },        -- ← ИСПРАВЛЕНО!
                lua = { "luacheck" },
                python = { "pylint" },
                rust = { "cargo" },
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                json = { "jsonlint" },
                yaml = { "yamllint" },
                markdown = { "markdownlint" },
            }
            
            -- Настройки для golangci-lint (Go)
            lint.linters["golangci-lint"] = {    -- ← ИСПРАВЛЕНО!
                cmd = "golangci-lint",
                args = { "run", "--fix=false", "--out-format", "json", "--print-issued-lines=false" },
                parser = function(output, bufnr)
                    local ok, decoded = pcall(vim.json.decode, output)
                    if not ok then
                        return {}
                    end
                    
                    local diagnostics = {}
                    local bufname = vim.api.nvim_buf_get_name(bufnr)
                    
                    for _, issue in ipairs(decoded.Issues or {}) do
                        if issue.Pos.Filename == bufname or issue.Pos.Filename == vim.fn.fnamemodify(bufname, ":.") then
                            table.insert(diagnostics, {
                                lnum = issue.Pos.Line - 1,
                                col = issue.Pos.Column - 1,
                                severity = vim.diagnostic.severity.WARN,
                                message = issue.Text,
                                source = issue.FromLinter,
                            })
                        end
                    end
                    
                    return diagnostics
                end,
            }
            
            -- Автолинтинг при сохранении
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
            
            -- Клавиша для ручного линтинга
            vim.keymap.set("n", "<leader>ll", function()
                lint.try_lint()
            end, { desc = "Lint current file" })
        end,
    },
}
