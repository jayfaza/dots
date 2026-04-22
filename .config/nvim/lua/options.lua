-- ============================================================
-- EDITOR OPTIONS
-- Only vim.opt / vim.g / vim.o here — no logic
-- ============================================================

vim.g.mapleader      = " "
vim.g.maplocalleader = ","

-- Appearance
vim.opt.number        = true
vim.opt.termguicolors = true
vim.opt.showmode      = false   -- don't show -- INSERT -- in cmdline (lualine handles it)
vim.opt.scrolloff     = 5       -- keep 5 lines above/below cursor
vim.opt.signcolumn    = "no"
vim.opt.fillchars     = {       -- hide split border characters
	vert      = " ",
	horiz     = " ",
	horizup   = " ",
	horizdown = " ",
	vertleft  = " ",
	vertright = " ",
	verthoriz = " ",
}
vim.o.background = "dark"

-- Search
vim.opt.ignorecase = true   -- case-insensitive search...
vim.opt.smartcase  = true   -- ...unless query has uppercase letters

-- Buffer / files
vim.opt.clipboard = "unnamedplus"  -- use system clipboard
vim.opt.hidden    = true           -- allow switching buffers without saving
vim.opt.swapfile  = false
vim.opt.backup    = false
vim.opt.undofile  = true           -- persistent undo across sessions
vim.opt.undodir   = vim.fn.stdpath("data") .. "/undo"

-- Mouse and performance
vim.opt.mouse      = "a"    -- enable mouse in all modes
vim.opt.updatetime = 300    -- faster CursorHold / LSP response

-- Splits
vim.opt.splitright = true   -- vsplit opens to the right
vim.opt.splitbelow = true   -- split opens below

-- Messages
vim.opt.shortmess:append("c")  -- no "match x of y" completion messages
vim.opt.shortmess:append("s")  -- no "search hit BOTTOM" messages
vim.opt.shortmess:append("I")  -- no intro message on startup

-- Wildmenu (command-line completion)
vim.opt.wildmenu = true
vim.opt.wildmode = "longest,list,full"

-- Indentation (default — overridden per filetype in autocmds.lua)
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.softtabstop = 4
vim.opt.expandtab   = true
vim.opt.autoindent  = true
vim.opt.smartindent = true

-- Completion
vim.opt.completeopt = "menuone,noselect,preview"

-- Spell — disabled globally (enabled per filetype in autocmds.lua)
vim.opt.spell = false

-- Shell
vim.opt.shell        = "/usr/bin/zsh"
vim.opt.shellcmdflag = "-c"

-- LSP diagnostics — disabled globally, toggle with <leader>ud
vim.diagnostic.enable(false)
vim.diagnostic.config({
	virtual_text = false,
	signs        = false,
	underline    = false,
})

-- Create undo directory if it doesn't exist
vim.fn.mkdir(vim.fn.stdpath("data") .. "/undo", "p")
