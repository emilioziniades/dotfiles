local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
]])

-- caching
require("impatient")

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- FUNCTIONALITY

	--lsp
	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("config.lsp")
		end,
	})
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.null-ls")
		end,
	})
	use("onsails/lspkind-nvim")

	-- git
	use("tpope/vim-fugitive")
	use({
		"TimUntersberger/neogit",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("neogit").setup()
		end,
	})
	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.gitsigns")
		end,
	})

	-- tree file explorer
	use({
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup()
		end,
	})
	use("kyazdani42/nvim-web-devicons")

	-- telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.telescope")
		end,
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	-- status line
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("config.lualine")
		end,
	})

	-- snippets
	use({
		"L3MON4D3/LuaSnip",
		config = function()
			require("config.snippets")
		end,
	})

	-- completion
	use({
		"hrsh7th/nvim-cmp",
		config = function()
			require("config.cmp")
		end,
	})
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")
	use("hrsh7th/cmp-cmdline")
	use("saadparwaiz1/cmp_luasnip")

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("config.treesitter")
		end,
	})
	use("nvim-treesitter/nvim-treesitter-textobjects")

	-- commenting
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	-- startup screen
	use({
		"startup-nvim/startup.nvim",
		requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("startup").setup()
		end,
	})

	-- show indents
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("config.indent-blankline")
		end,
	})

	-- auto tags
	use("ludovicchabant/vim-gutentags")

	--brackets
	use("machakann/vim-sandwich")
	use("jiangmiao/auto-pairs")
	use("p00f/nvim-ts-rainbow")

	--zen mode
	use({
		"folke/zen-mode.nvim",
		config = function()
			require("config.zen-mode")
		end,
	})

	use({
		"folke/twilight.nvim",
		config = function()
			require("twilight").setup()
		end,
	})

	-- floating terminal
	use("numToStr/FTerm.nvim")

	-- optimize startup
	use("lewis6991/impatient.nvim")

	-- auto save
	use({
		"Pocco81/AutoSave.nvim",
		config = function()
			require("config.autosave")
		end,
	})

	-- markdown preview
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && yarn install",
		ft = "markdown",
	})

	-- THEMES

	use("folke/tokyonight.nvim")
	-- use("shaunsingh/nord.nvim")
	-- use("Mofiqul/dracula.nvim")
	-- use("mjlbach/onedark.nvim")
	-- use("sjl/badwolf")
	-- use("tanvirtin/monokai.nvim")
	-- use("morhetz/gruvbox")
	-- use({ "rose-pine/neovim", as = "rose-pine" })
end)
