-- ============================================================
-- UI TOGGLES
-- Загружает сохранённое состояние при старте,
-- сохраняет при каждом изменении.
-- ============================================================

local M = {}

local state_path = vim.fn.stdpath("config") .. "/lua/ui_state.lua"

-- Записывает текущее состояние на диск
local function save(state)
	local f = io.open(state_path, "w")
	if not f then return end
	f:write("-- Состояние UI toggles — файл перезаписывается автоматически\n\n")
	f:write("return {\n")
	for k, v in pairs(state) do
		f:write(string.format("\t%-15s = %s,\n", k, tostring(v)))
	end
	f:write("}\n")
	f:close()
end

-- Применяет состояние к редактору
local function apply(state)
	vim.opt.number         = state.number
	vim.opt.relativenumber = state.relativenumber
	vim.opt.cursorline     = state.cursorline
	vim.opt.wrap           = state.wrap
	vim.opt.laststatus     = state.statusline and 2 or 0

	if state.diagnostics then
		vim.diagnostic.enable()
		vim.diagnostic.config({ virtual_text = true, signs = true, underline = true })
	else
		vim.diagnostic.enable(false)
		vim.diagnostic.config({ virtual_text = false, signs = false, underline = false })
	end

	vim.lsp.inlay_hint.enable(state.inlay_hints)

	local ok_ibl, ibl = pcall(require, "ibl")
	if ok_ibl then
		ibl.update({ enabled = state.indent_guides })
	end

	if state.transparent then
		vim.api.nvim_set_hl(0, "Normal",      { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	end

	if state.rainbow then
		pcall(vim.cmd, "TSEnable rainbow")
	else
		pcall(vim.cmd, "TSDisable rainbow")
	end
end

-- Загружает состояние и применяет при старте
function M.load()
	local ok, state = pcall(dofile, state_path)
	if not ok or type(state) ~= "table" then return end
	-- Применяем с задержкой — плагины должны загрузиться
	vim.defer_fn(function() apply(state) end, 100)
end

-- Toggle: name = ключ в state, action = функция(новое_значение)
function M.toggle(name, action)
	local ok, state = pcall(dofile, state_path)
	if not ok or type(state) ~= "table" then return end
	state[name] = not state[name]
	action(state[name])
	save(state)
	return state[name]
end

return M
