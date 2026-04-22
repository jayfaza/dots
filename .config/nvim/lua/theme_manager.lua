local M = {}

local config_path = vim.fn.stdpath("config") .. "/lua/saved_theme.lua"

function M.load_saved()
	local ok, theme = pcall(dofile, config_path)
	if ok and theme and theme.name then
		pcall(vim.cmd.colorscheme, theme.name)
	end
end

function M.save(name)
	local f = io.open(config_path, "w")
	if f then
		f:write(string.format('return { name = "%s" }\n', name))
		f:close()
	end
end

return M
