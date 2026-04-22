return {

	-- blink.cmp (autocompletion)
	{
		"saghen/blink.cmp",
		dependencies = {
			{ "L3MON4D3/LuaSnip", version = "v2.*" },
			"rafamadriz/friendly-snippets",
		},
		version = "1.*",
		opts = {
			keymap = {
				["<C-Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<CR>"] = { "select_and_accept", "fallback" },
				["<C-e>"] = { "hide", "fallback" },
				["<C-i>"] = { "show_documentation", "hide_documentation", "fallback" },
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
			},
			appearance = { nerd_font_variant = "mono" },
			completion = {
				accept = { auto_brackets = { enabled = true } },
				trigger = {
					show_on_insert_on_trigger_character = false,
					show_on_accept_on_trigger_character = false,
					show_on_blocked_trigger_characters = { "{", "(", "}", ")" },
				},
				list = { max_items = 3 },
				documentation = {
					auto_show = false,
					window = { border = "none" },
				},
				menu = {
					auto_show = true,
					scrollbar = false,
					border = "none",
					draw = {
						columns = { { "kind_icon" }, { "label" } },
						components = {
							kind_icon = {
								ellipsis = false,
								width = { fixed = 2 },
								text = function(ctx)
									local icons = {
										Function = "λ",
										Method = "∂",
										Field = "•",
										Variable = "v",
										Property = "p",
										Keyword = "k",
										Struct = "S",
										Enum = "E",
										EnumMember = "e",
										Snippet = "⟨⟩",
										Text = "T",
										Module = "M",
										Constructor = "C",
										Interface = "I",
										Class = "c",
										Constant = "π",
										TypeParameter = "τ",
									}
									return icons[ctx.kind] or ctx.kind_icon
								end,
							},
							label = {
								width = { min = 15, max = 30 },
							},
						},
					},
				},
			},
			snippets = { preset = "luasnip" },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},

	-- LuaSnip + набор сниппетов
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{ "rafamadriz/friendly-snippets" },

	-- Noice (красивый cmdline, messages, notify — заменяет wilder)
	{
		"folke/noice.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			require("noice").setup({
				lsp = {
					signature = { enabled = false },
					hover = { enabled = false },
					progress = { enabled = false },
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
				},
				cmdline = {
					view = "cmdline_popup",
					format = {
						cmdline     = { icon = ">" },
						search_down = { icon = "/" },
						search_up   = { icon = "?" },
					},
				},
				-- Подсказки файлов и команд в popupmenu над cmdline
				popupmenu = {
					enabled = true,
					backend = "nui",
					kind_icons = false,
				},
				messages = { enabled = true },
				notify   = { enabled = true },
			})
		end,
	},

	-- Mason (управление LSP, линтерами, форматтерами)
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"pyright",
					"clangd",
					"ts_ls",
					"html",
					"jsonls",
					"yamlls",
					"bashls",
					"marksman",
					"lua_ls",
				},
				automatic_installation = true,
			})
		end,
	},

	-- nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			vim.lsp.handlers["$/progress"] = function() end
			vim.lsp.handlers["window/logMessage"] = function() end

			local orig_sig = vim.lsp.handlers["textDocument/signatureHelp"]
			vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
				if err and (err.code == -32801 or err.code == -32800) then
					return
				end
				if orig_sig then
					orig_sig(err, result, ctx, config)
				end
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local buf = args.buf
					vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = buf, silent = true })
					vim.keymap.set("i", "<C-d>", vim.lsp.buf.hover, { buffer = buf, silent = true })
				end,
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lspconfig = require("lspconfig")
			local opts = { capabilities = capabilities }

			if vim.fn.executable("rust-analyzer") == 0 then
				vim.notify("rust-analyzer не установлен! Установите: rustup component add rust-analyzer", vim.log.levels.WARN)
			else
				lspconfig.rust_analyzer.setup(vim.tbl_deep_extend("force", opts, {
					root_dir = function(fname)
						local util = require("lspconfig.util")
						return util.root_pattern("Cargo.toml", "rust-project.json")(fname)
							or util.find_git_ancestor(fname)
					end,
					single_file_support = true,
					settings = {
						["rust-analyzer"] = {
							check = { command = "clippy", allTargets = false },
							cargo = { allFeatures = false },
							procMacro = { enable = false },
							hover = { actions = { enable = false } },
							lens = { enable = false },
							completion = { fullFunctionSignatures = { enable = false } },
							files = { watcher = "client" },
						},
					},
				}))
			end

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
					},
				},
			})
		end,
	},
}
