-- ============================================================
-- АВТОКОМАНДЫ
-- Всё что должно реагировать на события редактора
-- ============================================================

-- ------------------------------------------------------------
-- ТЕМА: сохранение и восстановление
-- ------------------------------------------------------------

-- Флаг — не сохранять тему пока открыт Lazy (он сам меняет colorscheme)
_G._lazy_open = false

-- Сохраняем текущую тему в файл при каждой смене
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		if _G._lazy_open then return end
		local name = vim.g.colors_name
		if not name then return end
		local path = vim.fn.stdpath("config") .. "/lua/saved_theme.lua"
		local f = io.open(path, "w")
		if f then
			f:write(string.format('return { name = "%s" }\n', name))
			f:close()
		end
	end,
})

-- Когда Lazy открывается — останавливаем сохранение темы
vim.api.nvim_create_autocmd("User", {
	pattern  = "LazyShow",
	callback = function() _G._lazy_open = true end,
})

-- Когда Lazy закрывается — восстанавливаем нашу тему
vim.api.nvim_create_autocmd("User", {
	pattern  = "LazyDismiss",
	callback = function()
		_G._lazy_open = false
		require("theme_manager").load_saved()
	end,
})

-- ------------------------------------------------------------
-- КУРСОР: цвет берётся из текущей темы
-- ------------------------------------------------------------
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
		if not (hl and hl.fg) then return end
		local color = string.format("#%06x", hl.fg)
		vim.cmd("set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor")
		vim.cmd(string.format("highlight Cursor  guifg=%s guibg=%s", color, color))
		vim.cmd(string.format("highlight lCursor guifg=%s guibg=%s", color, color))
	end,
})

-- ------------------------------------------------------------
-- ДИАГНОСТИКА: некоторые темы включают underline — глушим
-- ------------------------------------------------------------
local function clear_diagnostic_hl()
	for _, s in ipairs({ "Error", "Warn", "Info", "Hint" }) do
		vim.api.nvim_set_hl(0, "DiagnosticUnderline" .. s, { underline = false, undercurl = false })
	end
end

clear_diagnostic_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = clear_diagnostic_hl })

-- LSP не должен включать диагностику при подключении к буферу
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.diagnostic.enable(false, { bufnr = args.buf })
	end,
})

-- ------------------------------------------------------------
-- SPELL: некоторые темы и ftplugin включают spell — глушим
-- ------------------------------------------------------------
local function kill_spell()
	vim.opt.spell       = false
	vim.opt_local.spell = false
	vim.api.nvim_set_hl(0, "SpellBad",   { undercurl = false, underline = false })
	vim.api.nvim_set_hl(0, "SpellCap",   { undercurl = false, underline = false })
	vim.api.nvim_set_hl(0, "SpellRare",  { undercurl = false, underline = false })
	vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = false, underline = false })
end

kill_spell()
vim.api.nvim_create_autocmd("ColorScheme",           { callback = kill_spell })
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, { callback = kill_spell })

-- ------------------------------------------------------------
-- ОТСТУПЫ: разные значения для разных языков
-- ------------------------------------------------------------
local lang_indent = {
	lua        = 2,
	html       = 2,
	css        = 2,
	javascript = 2,
	typescript = 2,
	python     = 4,
}

vim.api.nvim_create_autocmd("FileType", {
	pattern  = "*",
	callback = function()
		local sw = lang_indent[vim.bo.filetype]
		if sw then
			vim.bo.shiftwidth = sw
			vim.bo.tabstop    = sw
		end
	end,
})
