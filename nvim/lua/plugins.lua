local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
	Packer_bootstrap =
		vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd("packadd packer.nvim")
end

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "plugins.lua",
	group = vim.api.nvim_create_augroup("packer_user_config", { clear = true }),
	callback = function()
		vim.schedule(function()
			vim.cmd("source % | PackerCompile ")
		end)
	end,
})

return require("packer").startup(function(use)
	use({
		"wbthomason/packer.nvim",
		config = function()
			require("config.packer")
		end,
	})

	-- FUNCTIONALITY

	--lsp
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("onsails/lspkind-nvim")
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.null-ls")
		end,
	})
	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("config.lsp")
		end,
	})

	-- git
	use({
		"TimUntersberger/neogit",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("config.neogit")
		end,
	})
	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.gitsigns")
		end,
	})

	-- telescope
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-telescope/telescope-file-browser.nvim" })
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.telescope")
		end,
	})

	-- harpoon
	use({
		"ThePrimeagen/harpoon",
		config = function()
			require("config._harpoon")
		end,
	})

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
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
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

	-- debug
	use({
		"tpope/vim-scriptease",
		cmd = {
			"Messages", --view messages in quickfix list
		},
	})

	-- show indents
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("config.indent-blankline")
		end,
	})

	-- auto tags
	-- use("ludovicchabant/vim-gutentags")

	--brackets
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("config.autopairs")
		end,
	})
	use("machakann/vim-sandwich")
	use("p00f/nvim-ts-rainbow")

	-- COLOURSCHEMES

	use("sainnhe/sonokai")

	if Packer_bootstrap then
		require("packer").sync()
	end
end)
