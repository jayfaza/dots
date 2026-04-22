return {

	-- vesper (дефолтная тема)
	{
		"datsfilipe/vesper.nvim",
		priority = 1000,
		config = function()
			require("vesper").setup({
				transparent = false,
				italics = {
					comments = true,
					keywords = true,
					functions = true,
					strings = true,
					variables = true,
				},
				overrides = {},
				palette_overrides = {
					bg = "#020202",
				},
			})
			-- Ставим vesper только если нет сохранённой темы
			local config_path = vim.fn.stdpath("config") .. "/lua/saved_theme.lua"
			if not (vim.uv or vim.loop).fs_stat(config_path) then
				vim.cmd.colorscheme("vesper")
			end
		end,
	},

	-- moonfly (один раз, без дубля)
	{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },

	-- inlay hints
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		opts = {},
	},

	-- =============================================
	-- ПОПУЛЯРНЫЕ ТЁМНЫЕ ТЕМЫ
	-- =============================================
	{ "ellisonleao/gruvbox.nvim" },
	{ "sainnhe/gruvbox-material" },
	{ "sainnhe/edge" },
	{ "sainnhe/sonokai" },
	{ "sainnhe/everforest" },
	{ "folke/tokyonight.nvim" },
	{ "catppuccin/nvim", name = "catppuccin" },
	{ "Mofiqul/adwaita.nvim" },
	{ "Mofiqul/dracula.nvim" },
	{ "rebelot/kanagawa.nvim" },
	{ "navarasu/onedark.nvim" },
	{ "marko-cerovac/material.nvim" },
	{ "nyoom-engineering/oxocarbon.nvim" },
	{ "olimorris/onedarkpro.nvim" },
	{ "shaunsingh/nord.nvim" },
	{ "projekt0n/github-nvim-theme" },
	{ "neanias/everforest-nvim" },
	{ "ribru17/bamboo.nvim" },
	{ "EdenEast/nightfox.nvim" },
	{ "rose-pine/neovim", name = "rose-pine" },
	{ "craftzdog/solarized-osaka.nvim" },
	{ "dasupradyumna/midnight.nvim" },
	{ "tiagovla/tokyodark.nvim" },
	{ "nikolvs/vim-sunbather" },
	{ "ryanpcmcquen/true-monochrome_vim" },
	{ "ntk148v/komau.vim" },
	{ "olivercederborg/poimandres.nvim" },
	{ "dgox16/oldworld.nvim" },
	{ "uloco/bluloco.nvim", dependencies = "rktjmp/lush.nvim" },
	{ "kartikp10/noctis.nvim", dependencies = "rktjmp/lush.nvim" },
	{ "thesimonho/kanagawa-paper.nvim" },
	{ "zenbones-theme/zenbones.nvim", dependencies = "rktjmp/lush.nvim" },
	{ "oskarnurm/koda.nvim" },
	{ "n1ghtmare/noirblaze-vim" },
	{ "vague2k/vague.nvim" },
	{ "luisiacc/gruvbox-baby" },
	{ "bluz71/vim-nightfly-guicolors" },

	-- =============================================
	-- НОВЫЕ ТЕМЫ — ПАЧКА 1: МИНИМАЛИСТИЧНЫЕ / ТЁМНЫЕ
	-- =============================================
	{ "Shatur/neovim-ayu" },
	{ "vim-scripts/Spacegray.vim" },
	{ "mhartington/oceanic-next" },
	{ "joshdick/onedark.vim" },
	{ "dracula/vim", name = "dracula-vim" },
	{ "morhetz/gruvbox" },
	{ "AlessandroYorba/Sierra" },
	{ "AlessandroYorba/Alduin" },
	{ "junegunn/seoul256.vim" },
	{ "nanotech/jellybeans.vim" },
	{ "sjl/badwolf" },
	{ "w0ng/vim-hybrid" },
	{ "ciaranm/inkpot" },
	{ "jacoborus/tender.vim" },
	{ "cocopon/iceberg.vim" },
	{ "lifepillar/vim-solarized8" },
	{ "NLKNguyen/papercolor-theme" },
	{ "fxn/vim-monochrome" },

	-- =============================================
	-- НОВЫЕ ТЕМЫ — ПАЧКА 2: СОВРЕМЕННЫЕ / ПАСТЕЛЬНЫЕ
	-- =============================================
	{ "folke/lsp-colors.nvim" },
	{ "rmehri01/onenord.nvim" },
	{ "rafamadriz/neon" },
	{ "ray-x/aurora" },
	{ "yashguptaz/calvera-dark.nvim" },
	{ "glepnir/zephyr-nvim" },
	{ "Pocco81/TrueZen.nvim" },
	{ "savq/melange-nvim" },
	{ "fenetikm/falcon" },
	{ "humanoid-colors/vim-humanoid-colorscheme" },
	{ "whatyouhide/vim-gotham" },
	{ "habamax/vim-habamax" },
	{ "habamax/vim-gruvbit" },
	{ "habamax/vim-polar" },
	{ "habamax/vim-saturnite" },
	{ "challenger-deep-theme/vim", name = "challenger-deep" },
	{ "lifepillar/vim-gruvbox8" },
	{ "dim13/smyck.vim" },
	{ "mkarmona/materialbox" },

	-- =============================================
	-- НОВЫЕ ТЕМЫ — ПАЧКА 3: НЕОБЫЧНЫЕ / ЭКСПЕРИМЕНТАЛЬНЫЕ
	-- =============================================
	{ "echasnovski/mini.nvim", name = "mini-base16" },
	{ "lukas-reineke/indent-blankline.nvim" },
	{ "mellow-theme/mellow.nvim" },
	{ "ramojus/mellifluous.nvim" },
	{ "AlexvZyl/nordic.nvim" },
	{ "kvrohit/rasmus.nvim" },
	{ "kvrohit/mellow.nvim" },
	{ "Yazeed1s/minimal.nvim" },
	{ "Yazeed1s/oh-lucy.nvim" },
	{ "xero/miasma.nvim" },
	{ "shaunsingh/moonlight.nvim" },
	{ "shaunsingh/seoul256.nvim" },
	{ "ldelossa/vimdark" },
	{ "gbprod/nord.nvim" },
	{ "svrana/neosolarized.nvim", dependencies = "tjdevries/colorbuddy.nvim" },
	{ "maxmx03/fluoromachine.nvim" },
	{ "slugbyte/lackluster.nvim" },
	{ "0xstepit/flow.nvim" },

	-- =============================================
	-- НОВЫЕ ТЕМЫ — ПАЧКА 4: РЕТРО / СПЕЦИФИЧНЫЕ
	-- =============================================
	{ "sainnhe/vim-color-forest-night" },
	{ "jnurmine/Zenburn" },
	{ "tpope/vim-vividchalk" },
	{ "vim-scripts/xoria256.vim" },
	{ "fcpg/vim-fahrenheit" },
	{ "vim-scripts/Wombat" },
	{ "baskerville/bubblegum" },
	{ "raphamorim/lucario" },
	{ "nightsense/stellarized" },
	{ "YorickPeterse/vim-paper" },
	{ "KKPMW/sacredforest-vim" },
	{ "wimstefan/Lightning" },
	{ "Lokaltog/vim-monotone" },
	{ "pbrisbin/vim-colors-off" },
	{ "andreypopp/vim-colors-plain" },
	{ "logico/typewriter-vim" },
	{ "arzg/vim-colors-xcode" },
	{ "arzg/vim-substrata" },

	-- =============================================
	-- НОВЫЕ ТЕМЫ — ПАЧКА 5: СВЕЖИЕ 2023-2025
	-- =============================================
	{ "rebelot/terminal.nvim" },
	{ "cdmill/neomodern.nvim" },
	{ "killitar/obscure.nvim" },
	{ "blazkowolf/gruber-darker.nvim" },
	{ "Tsuzat/NeoSolarized.nvim" },
	{ "wnkz/monoglow.nvim" },
	{ "samharju/synthweave.nvim" },
	{ "loganswartz/sunburn.nvim" },
	{ "sho-87/kanagawa-paper.nvim" },
	{ "webhooked/kanso.nvim" },
	{ "meliora-theme/neovim", name = "meliora" },
	{ "miikanissi/modus-themes.nvim" },
	{ "zootedb0t/citruszest.nvim" },
	{ "tinted-theming/tinted-vim" },
}
