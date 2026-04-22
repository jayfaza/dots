local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Подавляем deprecated-предупреждения (lspconfig v3 migration, tbl_flatten и т.д.)
vim.deprecate = function() end

require("lazy").setup("plugins", {
	defaults = {
		lazy = false,
	},
})
