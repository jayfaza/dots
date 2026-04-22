-- ============================================================
-- ОСНОВНЫЕ НАСТРОЙКИ
-- Здесь только vim.opt / vim.g / vim.o — никакой логики
-- ============================================================

vim.g.mapleader      = " "
vim.g.maplocalleader = ","

-- Внешний вид
vim.opt.number        = true
vim.opt.termguicolors = true
vim.opt.showmode      = false
vim.opt.scrolloff     = 5
vim.opt.signcolumn    = "no"
vim.opt.fillchars     = {
	vert      = " ",
	horiz     = " ",
	horizup   = " ",
	horizdown = " ",
	vertleft  = " ",
	vertright = " ",
	verthoriz = " ",
}
vim.o.background = "dark"

-- Поиск
vim.opt.ignorecase = true
vim.opt.smartcase  = true

-- Буфер / файлы
vim.opt.clipboard = "unnamedplus"
vim.opt.hidden    = true
vim.opt.swapfile  = false
vim.opt.backup    = false
vim.opt.undofile  = true
vim.opt.undodir   = vim.fn.stdpath("data") .. "/undo"

-- Мышь и скорость
vim.opt.mouse      = "a"
vim.opt.updatetime = 300

-- Сплиты
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Сообщения
vim.opt.shortmess:append("c")
vim.opt.shortmess:append("s")
vim.opt.shortmess:append("I")

-- Wildmenu (автодополнение команд)
vim.opt.wildmenu = true
vim.opt.wildmode = "longest,list,full"

-- Отступы (дефолт — переопределяется по типу файла в autocmds.lua)
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.softtabstop = 4
vim.opt.expandtab   = true
vim.opt.autoindent  = true
vim.opt.smartindent = true

-- Автодополнение
vim.opt.completeopt = "menuone,noselect,preview"

-- Spell — выключен глобально
vim.opt.spell = false

-- Оболочка
vim.opt.shell        = "/bin/zsh-5.9"
vim.opt.shellcmdflag = "-c"

-- Диагностика LSP — полностью отключена
vim.diagnostic.enable(false)
vim.diagnostic.config({
	virtual_text = false,
	signs        = false,
	underline    = false,
})

-- Создаём папку для undo-истории если нет
vim.fn.mkdir(vim.fn.stdpath("data") .. "/undo", "p")
