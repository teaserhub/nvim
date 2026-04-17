
Ок, сделаем тебе **чистый, минималистичный стек без мусора**, но уже уровня “можно работать каждый день”.

Без перегруза плагинами, но с нормальным DX.

---

# 🧱 Стек

* LSP → `gopls`
* Автокомплит → `nvim-cmp`
* Форматирование → `gofmt` / LSP
* Поиск → `fzf-lua`
* Менеджер → `lazy.nvim`

---

# 📁 Структура (как у норм людей)

```
~/.config/nvim/
├── init.lua
└── lua/
    ├── core/
    │   ├── lazy.lua
    │   ├── keymaps.lua
    │   └── options.lua
    └── plugins/
        ├── lsp.lua
        ├── cmp.lua
        └── fzf.lua
```

---

# ⚙️ 1. `core/lazy.lua`

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
```

---

# ⚙️ 2. `init.lua`

```lua
require("core.options")
require("core.keymaps")
require("core.lazy")
```

---

# ⚙️ 3. `plugins/lsp.lua`

```lua
return {
    { "williamboman/mason.nvim", config = true },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },

        config = function()
            local lspconfig = require("lspconfig")
            local cmp_lsp = require("cmp_nvim_lsp")

            local capabilities = cmp_lsp.default_capabilities()

            local on_attach = function(_, bufnr)
                local opts = { buffer = bufnr }

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
            end

            require("mason-lspconfig").setup({
                ensure_installed = { "gopls" },
                handlers = {
                    function(server)
                        lspconfig[server].setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,

                    ["gopls"] = function()
                        lspconfig.gopls.setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = {
                                gopls = {
                                    staticcheck = true,
                                },
                            },
                        })
                    end,
                },
            })
        end,
    },
}
```

---

# ⚙️ 4. `plugins/cmp.lua`

```lua
return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },

    config = function()
        local cmp = require("cmp")

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<S-Tab>"] = cmp.mapping.select_prev_item(),
            }),

            sources = {
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
            },
        })
    end,
}
```

---

# ⚙️ 5. `plugins/fzf.lua`

```lua
return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
        local fzf = require("fzf-lua")

        vim.keymap.set("n", "<leader>ff", fzf.files)
        vim.keymap.set("n", "<leader>fg", fzf.live_grep)
        vim.keymap.set("n", "<leader>fb", fzf.buffers)
        vim.keymap.set("n", "<leader>fh", fzf.help_tags)
    end,
}
```

---

# ⚙️ 6. `core/options.lua`

```lua
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
```

---

# ⚙️ 7. `core/keymaps.lua`

```lua
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
```

---

# 🚀 Что у тебя теперь есть

👉 LSP:

* go to definition
* hover
* rename
* code actions

👉 CMP:

* автокомплит как в IDE

👉 FZF:

* поиск файлов `<leader>ff`
* grep `<leader>fg`

👉 Formatting:

* `<leader>f` через `gopls`

---

# 🧠 Что дальше (если захочешь апгрейд)

Следующие логичные шаги:

1. snippets (`luasnip`)
2. автопары (`nvim-autopairs`)
3. git (`gitsigns`)
4. oil.nvim вместо tree (ты уже почти там)

---

# ⚡ Важный момент

Это уже:

> **не “учебный конфиг”, а рабочий минимализм**

Без:

* перегруженных UI
* 40 плагинов
* лагов

---

Если хочешь — дальше сделаем тебе:
👉 **“production стиль” workflow (как реально пишут Go сервисы)**
с hot reload, debugging и нормальной структурой проекта



Ок, давай без романтики — **“production стиль” в Go** это не про плагины, а про **workflow + структура + инструменты**.
Neovim тут просто интерфейс.

Соберу тебе **реальный пайплайн, как пишут сервисы**, но без перегруза.

---

# 🧠 Как реально пишут Go сервисы

Типичный цикл:

```
код → сохранить → автоформат → авто reload → логи → тест → повтор
```

А не:

> написал → руками перезапустил → потерял время

---

# 🧱 1. Структура проекта (минимально правильная)

```id="n4o8r7"
myapp/
├── cmd/
│   └── api/
│       └── main.go
├── internal/
│   ├── handler/
│   ├── service/
│   └── repo/
├── go.mod
└── Makefile
```

📌 Почему так:

* `cmd/` → точки входа
* `internal/` → бизнес-логика (не экспортируется наружу)

---

# ⚡ 2. Hot Reload (ОБЯЗАТЕЛЬНО)

Ставь:

```bash
go install github.com/air-verse/air@latest
```

---

## Конфиг `.air.toml`

```toml id="lb8nwp"
root = "."
tmp_dir = "tmp"

[build]
cmd = "go build -o ./tmp/main ./cmd/api"
bin = "tmp/main"
full_bin = "APP_ENV=dev ./tmp/main"
include_ext = ["go"]
exclude_dir = ["tmp", "vendor"]

[log]
time = true
```

---

## Запуск

```bash
air
```

👉 Теперь:

* сохранил файл → сервер перезапустился сам

---

# 🔥 3. Форматирование + линтер

## Минимум:

```bash
go install golang.org/x/tools/cmd/goimports@latest
```

---

## Лучше (как в проде):

```bash
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

---

## Конфиг `.golangci.yml`

```yaml id="a2p8xk"
run:
  timeout: 5m

linters:
  enable:
    - govet
    - staticcheck
    - errcheck
```

---

## Проверка

```bash
golangci-lint run
```

---

# ⚙️ 4. Makefile (реальный стандарт)

```makefile id="3sdm0s"
run:
	air

build:
	go build -o bin/app ./cmd/api

test:
	go test ./...

lint:
	golangci-lint run

fmt:
	goimports -w .
```

---

# 🚀 5. Debugging (без боли)

Ставишь:

```bash
go install github.com/go-delve/delve/cmd/dlv@latest
```

---

## Запуск

```bash
dlv debug ./cmd/api
```

---

# 🔍 6. FZF + LSP workflow

Теперь твои реальные движения:

### Навигация

* `gd` → код
* `gr` → usage
* `<leader>ff` → файлы
* `<leader>fg` → поиск по проекту

---

### Типичный кейс

1. `<leader>fg` → нашёл handler
2. `gd` → перешёл в service
3. поменял код
4. сохранил
5. air сам перезапустил
6. смотришь логи

---

# 🧪 7. Тесты (обязательно)

```bash
go test ./...
```

или конкретно:

```bash
go test ./internal/service -v
```

---

# 📦 8. Минимальный main.go

```go id="0v2m8h"
package main

import (
	"log"
	"net/http"
)

func main() {
	mux := http.NewServeMux()

	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("OK"))
	})

	log.Println("server started on :8080")
	log.Fatal(http.ListenAndServe(":8080", mux))
}
```

---

# 🧠 Как выглядит реальный workflow

Ты сидишь в nvim:

```
:air запущен в терминале
```

Дальше:

* пишешь код
* `:w`
* смотришь логи
* фикcишь
* `gd / gr` навигация
* `golangci-lint` перед коммитом

---

# ⚠️ Где новички ломаются

1. ❌ Нет hot reload → теряют время
2. ❌ Нет линтера → пишут мусор
3. ❌ Пихают всё в main.go
4. ❌ Не используют internal

---

# 💀 Честно

VSCode даёт это “из коробки”.
Ты сейчас собираешь это руками — это нормально.

Но плюс:

> ты начинаешь понимать систему, а не кнопки

---

# 🚀 Если хочешь следующий уровень

Могу собрать тебе дальше:

* Docker + docker-compose
* PostgreSQL
* миграции (`migrate`)
* config через env
* structured logging (`zap`)
* real CRUD API

Это уже будет:

> **уровень джуна/мидла, а не “учусь Go”**
