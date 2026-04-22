return {

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		version = "*",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"rust",
					"lua",
					"python",
					"javascript",
					"typescript",
					"c",
					"cpp",
					"json",
					"yaml",
					"bash",
					"markdown",
					"markdown_inline",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					preview = { treesitter = false },
					prompt_prefix = "  ",
					selection_caret = " ",
					entry_prefix = "  ",
					border = true,
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					layout_config = {
						horizontal = { preview_width = 0.55 },
						width = 0.87,
						height = 0.80,
					},
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<esc>"] = actions.close,
						},
					},
				},
				pickers = {
					find_files = { hidden = true },
					colorscheme = { enable_preview = true },
				},
			})
		end,
	},

	-- Conform (formatting)
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black" },
					rust = { "rustfmt" },
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					html = { "prettier" },
					json = { "prettier" },
					markdown = { "prettier" },
					css = { "prettier" },
					yaml = { "yamlfmt" },
					go = { "goimports" },
				},
				format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
			})
		end,
	},

	-- Lualine (statusline)
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			local function setup_lualine()
				require("lualine").setup({
					options = {
						icons_enabled = true,
						theme = "auto",
						component_separators = "",
						section_separators = "",
					},
					sections = {
						lualine_a = { "mode" },
						lualine_b = { "branch" },
						lualine_c = { "filename" },
						lualine_x = {
							"filetype",
							{
								function()
									local icons = { unix = "\u{f31a}", dos = "\u{e70f}", mac = "\u{f179}" }
									local ff = vim.bo.fileformat
									return (icons[ff] or ff) .. " " .. ff
								end,
							},
						},
						lualine_y = { "location" },
						lualine_z = {
							function()
								return os.date("%I:%M%p")
							end,
						},
					},
				})
			end

			setup_lualine()

			-- Пересоздаём lualine при смене темы — иначе цвета остаются от старой
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					vim.defer_fn(setup_lualine, 10)
				end,
			})
		end,
	},

	-- Mini icons
	{
		"echasnovski/mini.icons",
		config = function()
			require("mini.icons").setup()
		end,
	},

	-- Mini misc (termbg sync — фон терминала = фон темы)
	{
		"echasnovski/mini.misc",
		config = function()
			local misc = require("mini.misc")
			misc.setup({})
			misc.setup_termbg_sync()
		end,
	},

	-- Nvim-tree
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				hijack_cursor = true,
				git = { enable = true },
			})
		end,
	},

	-- vim-surround
	{ "tpope/vim-surround" },

	-- vim-commentary
	{ "tpope/vim-commentary" },

	-- Autopairs (авто-скобки и кавычки)
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				disable_filetype = { "TelescopePrompt", "vim" },
			})
		end,
	},

	-- Colorizer (показывает цвета из hex)
	{
		"norcalli/nvim-colorizer.lua",
		event = "BufReadPost",
		config = function()
			require("colorizer").setup({ "*" })
		end,
	},

	-- nvim-notify (красивые уведомления)
	{
		"rcarriga/nvim-notify",
		config = function()
			local notify = require("notify")
			notify.setup({
				background_colour = "#020202",
				fps = 60,
				max_width = 60,
				min_width = 0,
				max_height = 30,
				min_height = 0,
				stages = "slide",
				timeout = 1500,
				top_down = false,
			})
			-- Перехватываем vim.notify чтобы все плагины использовали nvim-notify
			vim.notify = function(msg, level, opts)
				notify(msg, level, opts)
			end
		end,
	},

	-- Which-key (подсказки биндов)
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
			layout = { width = { min = 25, max = 55 }, height = { min = 4, max = 20 } },
			win = {
				noautocmd = true,
				border = "rounded",
				padding = { 1, 2 },
			},
			delay = 200,
		},
	},
	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
		end,
	},

	-- Dressing (красивые vim.ui.input и vim.ui.select — LSP rename, code action)
	{
		"stevearc/dressing.nvim",
		opts = {
			input = {
				border = "rounded",
				win_options = { winblend = 0 },
			},
			select = {
				backend = { "telescope", "builtin" },
			},
		},
	},

	-- Indent Blankline (линии отступов + подсветка текущего scope)
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup({
				indent = { char = "│", tab_char = "│" },
				scope = { enabled = true, show_start = false, show_end = false },
				exclude = {
					filetypes = { "help", "dashboard", "lazy", "mason", "notify", "toggleterm" },
				},
			})
		end,
	},

	-- Rainbow Delimiters (цветные скобки по уровням)
	{
		"HiPhish/rainbow-delimiters.nvim",
		config = function()
			require("rainbow-delimiters.setup").setup({
				strategy = { [""] = require("rainbow-delimiters").strategy["global"] },
				query = { [""] = "rainbow-delimiters" },
			})
		end,
	},

	-- ToggleTerm (терминал)
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return math.floor(vim.o.columns * 0.4)
					end
				end,
				open_mapping = nil, -- биндим вручную
				direction = "horizontal",
				shade_terminals = false,
				persist_size = true,
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "rounded",
					width = math.floor(vim.o.columns * 0.85),
					height = math.floor(vim.o.lines * 0.80),
				},
			})

			-- Выход из terminal mode по <Esc>
			vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })
		end,
	},
}
