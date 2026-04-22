-- ============================================================
-- WHICH-KEY — описания биндингов
-- Открывается автоматически после задержки при нажатии <leader>
-- ============================================================

vim.api.nvim_create_autocmd("User", {
	pattern  = "VeryLazy",
	callback = function()
		local wk = require("which-key")

		wk.add({
			-- Группы (папки в which-key меню)
			{ "<leader>f", group = "Find" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>w", group = "Windows" },
			{ "<leader>t", group = "Terminal" },
			{ "<leader>c", group = "Code" },
			{ "<leader>u", group = "UI Toggles" },

			-- Табы
			{ "<leader>tn", desc = "New tab" },
			{ "<leader>tc", desc = "Close tab" },
			{ "<leader>1",  desc = "Tab 1" },
			{ "<leader>2",  desc = "Tab 2" },
			{ "<leader>3",  desc = "Tab 3" },
			{ "<leader>4",  desc = "Tab 4" },
			{ "<leader>5",  desc = "Tab 5" },
			{ "<leader>6",  desc = "Tab 6" },
			{ "<leader>7",  desc = "Tab 7" },
			{ "<leader>8",  desc = "Tab 8" },
			{ "<leader>9",  desc = "Last tab" },

			-- Окна
			{ "<leader>wv", desc = "Vertical split" },
			{ "<leader>ws", desc = "Horizontal split" },
			{ "<leader>wc", desc = "Close window" },
			{ "<leader>wo", desc = "Close others" },

			-- LSP
			{ "<leader>lr", desc = "Rename symbol" },
			{ "<leader>la", desc = "Code action" },
			{ "<leader>li", desc = "Toggle inlay hints" },
			{ "gd",         desc = "Go to definition" },
			{ "gr",         desc = "References" },
			{ "gD",         desc = "Declaration" },
			{ "gi",         desc = "Implementation" },
			{ "K",          desc = "Hover docs" },
			{ "[e",         desc = "Prev diagnostic" },
			{ "]e",         desc = "Next diagnostic" },

			-- Поиск
			{ "<leader>ff", desc = "Find files" },
			{ "<leader>fg", desc = "Live grep" },
			{ "<leader>fb", desc = "Buffers" },
			{ "<leader>fr", desc = "Recent files" },
			{ "<leader>fh", desc = "Help tags" },
			{ "<C-n>",      desc = "Colorscheme picker" },

			-- Файловый менеджер
			{ "<leader>e",  desc = "File explorer" },

			-- Терминал
			{ "<leader>th", desc = "Terminal horizontal" },
			{ "<leader>tv", desc = "Terminal vertical" },
			{ "<leader>tf", desc = "Terminal float" },

			-- Код
			{ "<leader>cf", desc = "Format file" },

			-- UI Toggles
			{ "<leader>un", desc = "Line numbers" },
			{ "<leader>ur", desc = "Relative numbers" },
			{ "<leader>ui", desc = "Indent guides" },
			{ "<leader>uc", desc = "Cursorline" },
			{ "<leader>uw", desc = "Word wrap" },
			{ "<leader>ud", desc = "Diagnostics" },
			{ "<leader>ut", desc = "Transparent bg" },
			{ "<leader>ub", desc = "Rainbow brackets" },
			{ "<leader>us", desc = "Statusline" },
			{ "<leader>li", desc = "Inlay hints" },

			-- Insert mode
			{ "<C-k>", desc = "Signature help",       mode = "i" },
			{ "<C-d>", desc = "Hover docs",            mode = "i" },
			{ "<C-i>", desc = "Toggle completion docs", mode = "i" },

			-- Visual mode
			{ "J", desc = "Move selection down", mode = "v" },
			{ "K", desc = "Move selection up",   mode = "v" },
		})
	end,
})
