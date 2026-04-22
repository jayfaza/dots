-- ============================================================
-- БИНДИНГИ
-- Формат: km("режим", "клавиша", действие, { desc = "..." })
-- Режимы: "n" = normal, "i" = insert, "v" = visual, "t" = terminal
-- ============================================================

local km = vim.keymap.set

-- ------------------------------------------------------------
-- ТАБЫ
-- ------------------------------------------------------------
km("n", "<C-Right>",   vim.cmd.tabnext,     { desc = "Next tab" })
km("n", "<C-Left>",    vim.cmd.tabprevious, { desc = "Prev tab" })
km("n", "<C-PageDown>", vim.cmd.tabnext)
km("n", "<C-PageUp>",   vim.cmd.tabprevious)
km("n", "<leader>tn",  vim.cmd.tabnew,      { desc = "New tab" })
km("n", "<leader>tc",  vim.cmd.tabclose,    { desc = "Close tab" })

-- <leader>1-9 для быстрого перехода к табу
for i = 1, 9 do
	km("n", "<leader>" .. i, function()
		vim.cmd(i == 9 and "tablast" or "tabnext " .. i)
	end, { desc = i == 9 and "Last tab" or "Tab " .. i })
end

-- ------------------------------------------------------------
-- ОКНА
-- ------------------------------------------------------------
km("n", "<C-h>", "<C-w>h", { desc = "Window left" })
km("n", "<C-j>", "<C-w>j", { desc = "Window down" })
km("n", "<C-k>", "<C-w>k", { desc = "Window up" })
km("n", "<C-l>", "<C-w>l", { desc = "Window right" })

km("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
km("n", "<leader>ws", "<cmd>split<cr>",  { desc = "Horizontal split" })
km("n", "<leader>wc", "<cmd>close<cr>",  { desc = "Close window" })
km("n", "<leader>wo", "<cmd>only<cr>",   { desc = "Close others" })

km("n", "=", "<cmd>vertical resize +5<cr>",   { desc = "Width +" })
km("n", "-", "<cmd>vertical resize -5<cr>",   { desc = "Width -" })
km("n", "+", "<cmd>horizontal resize +5<cr>", { desc = "Height +" })

-- ------------------------------------------------------------
-- НАВИГАЦИЯ
-- ------------------------------------------------------------
km("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
km("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

km("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
km("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ------------------------------------------------------------
-- LSP
-- ------------------------------------------------------------
km("n", "K",           vim.lsp.buf.hover,        { desc = "Hover docs" })
km("n", "gd",          vim.lsp.buf.definition,   { desc = "Go to definition" })
km("n", "gr",          vim.lsp.buf.references,   { desc = "References" })
km("n", "gD",          vim.lsp.buf.declaration,  { desc = "Declaration" })
km("n", "gi",          vim.lsp.buf.implementation, { desc = "Implementation" })
km("n", "<leader>lr",  vim.lsp.buf.rename,       { desc = "Rename symbol" })
km("n", "<leader>la",  vim.lsp.buf.code_action,  { desc = "Code action" })
km("n", "[e",          vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
km("n", "]e",          vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- ------------------------------------------------------------
-- КОД
-- ------------------------------------------------------------
km("n", "<leader>cf", function()
	require("conform").format({ async = true })
end, { desc = "Format file" })

-- ------------------------------------------------------------
-- TELESCOPE (поиск)
-- ------------------------------------------------------------
km("n", "<leader>ff", function() require("telescope.builtin").find_files() end,  { desc = "Find files" })
km("n", "<leader>fg", function() require("telescope.builtin").live_grep() end,   { desc = "Live grep" })
km("n", "<leader>fb", function() require("telescope.builtin").buffers() end,     { desc = "Buffers" })
km("n", "<leader>fr", function() require("telescope.builtin").oldfiles() end,    { desc = "Recent files" })
km("n", "<leader>fh", function() require("telescope.builtin").help_tags() end,   { desc = "Help tags" })
km("n", "<C-n>",      function() require("telescope.builtin").colorscheme({ enable_preview = true }) end, { desc = "Colorscheme picker" })

-- ------------------------------------------------------------
-- ФАЙЛОВЫЙ МЕНЕДЖЕР
-- ------------------------------------------------------------
km("n", "<leader>e", "<CMD>Oil<CR>", { desc = "File explorer" })

-- ------------------------------------------------------------
-- ТЕРМИНАЛ
-- ------------------------------------------------------------
km("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Terminal horizontal" })
km("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>",   { desc = "Terminal vertical" })
km("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",      { desc = "Terminal float" })

-- ------------------------------------------------------------
-- ВИЗУАЛЬНЫЕ TOGGLES  (<leader>u = UI)
-- Все изменения сохраняются и восстанавливаются при следующем запуске
-- ------------------------------------------------------------

local T = require("ui_toggles")

km("n", "<leader>un", function()
	local v = T.toggle("number", function(val) vim.opt.number = val end)
	vim.notify("Line numbers " .. (v and "ON" or "OFF"))
end, { desc = "Toggle line numbers" })

km("n", "<leader>ur", function()
	local v = T.toggle("relativenumber", function(val) vim.opt.relativenumber = val end)
	vim.notify("Relative numbers " .. (v and "ON" or "OFF"))
end, { desc = "Toggle relative numbers" })

km("n", "<leader>ui", function()
	local v = T.toggle("indent_guides", function(val)
		local ok, ibl = pcall(require, "ibl")
		if ok then ibl.update({ enabled = val }) end
	end)
	vim.notify("Indent guides " .. (v and "ON" or "OFF"))
end, { desc = "Toggle indent guides" })

km("n", "<leader>uc", function()
	local v = T.toggle("cursorline", function(val) vim.opt.cursorline = val end)
	vim.notify("Cursorline " .. (v and "ON" or "OFF"))
end, { desc = "Toggle cursorline" })

km("n", "<leader>uw", function()
	local v = T.toggle("wrap", function(val) vim.opt.wrap = val end)
	vim.notify("Word wrap " .. (v and "ON" or "OFF"))
end, { desc = "Toggle word wrap" })

km("n", "<leader>ud", function()
	local v = T.toggle("diagnostics", function(val)
		if val then
			vim.diagnostic.enable()
			vim.diagnostic.config({ virtual_text = true, signs = true, underline = true })
		else
			vim.diagnostic.enable(false)
			vim.diagnostic.config({ virtual_text = false, signs = false, underline = false })
		end
	end)
	vim.notify("Diagnostics " .. (v and "ON" or "OFF"))
end, { desc = "Toggle diagnostics" })

km("n", "<leader>li", function()
	local v = T.toggle("inlay_hints", function(val)
		vim.lsp.inlay_hint.enable(val)
	end)
	vim.notify("Inlay hints " .. (v and "ON" or "OFF"))
end, { desc = "Toggle inlay hints" })

km("n", "<leader>ut", function()
	local v = T.toggle("transparent", function(val)
		if val then
			vim.api.nvim_set_hl(0, "Normal",      { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		else
			require("theme_manager").load_saved()
		end
	end)
	vim.notify("Transparent bg " .. (v and "ON" or "OFF"))
end, { desc = "Toggle transparent bg" })

km("n", "<leader>ub", function()
	local v = T.toggle("rainbow", function(val)
		pcall(vim.cmd, val and "TSEnable rainbow" or "TSDisable rainbow")
	end)
	vim.notify("Rainbow brackets " .. (v and "ON" or "OFF"))
end, { desc = "Toggle rainbow brackets" })

km("n", "<leader>us", function()
	local v = T.toggle("statusline", function(val)
		vim.opt.laststatus = val and 2 or 0
	end)
	vim.notify("Statusline " .. (v and "ON" or "OFF"))
end, { desc = "Toggle statusline" })
