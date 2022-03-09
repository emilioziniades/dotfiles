local vars = require("variables")

-- Packer - plugins

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.cmd([[
    augroup Packer
        autocmd!
        autocmd BufWritePost init.lua PackerCompile
    augroup end
]])

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	--functionality
	--    lsp
	use("neovim/nvim-lspconfig")
	use({ "jose-elias-alvarez/null-ls.nvim", requires = { "nvim-lua/plenary.nvim" } })
	--    git
	use("tpope/vim-fugitive")
	--    keystrokes
	use("numToStr/Comment.nvim")
	use("machakann/vim-sandwich")
	use("vim-scripts/auto-pairs-gentle")
	use("Pocco81/AutoSave.nvim")
	--    visual
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("nvim-lualine/lualine.nvim")
	use("p00f/nvim-ts-rainbow")
	use("junegunn/goyo.vim")
	use("kyazdani42/nvim-web-devicons")
	use("lukas-reineke/indent-blankline.nvim")
	use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })

	--    explorers & terminal
	use("kyazdani42/nvim-tree.lua")
	use("numToStr/FTerm.nvim")
	use({ "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } })
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	--themes
	use("shaunsingh/nord.nvim")
	-- use("Mofiqul/dracula.nvim")
	-- use("tanvirtin/monokai.nvim")
	-- use("mjlbach/onedark.nvim")
	-- use("sjl/badwolf")
	-- use("folke/tokyonight.nvim")
	-- use("morhetz/gruvbox")
	-- use({ "rose-pine/neovim", as = "rose-pine" })
end)

-- nvim-tree configuration
require("nvim-tree").setup()

--lualine configuration
require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = vars.lualinetheme,
		component_separators = "|",
		section_separators = "",
	},
})

--nvim-treesitter configuration
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
	},
	rainbow = {
		enable = true,
	},
	ensure_installed = {
		"go",
		"python",
		"javascript",
		"lua",
	},
})
vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")

-- Comment.nvim configuration
require("Comment").setup()

-- null-ls

local null_ls = require("null-ls")

local sources = {
	null_ls.builtins.formatting.black,
	null_ls.builtins.formatting.goimports,
	null_ls.builtins.formatting.prettier,
	null_ls.builtins.formatting.stylua,
}
null_ls.setup({
	sources = sources,
	on_attach = function(client)
		if client.resolved_capabilities.document_formatting then
			vim.cmd([[
                augroup LspFormatting
                    autocmd! * <buffer>
                    autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
                augroup END
                ]])
		end
	end,
})

-- telescope

require("telescope").setup()
require("telescope").load_extension("fzf")

-- AutoSave

require("autosave").setup({
	enabled = true,
	execution_message = "(autosaved) @ " .. vim.fn.strftime("%H:%M:%S"),
	events = { "InsertLeave", "TextChanged" },
	conditions = {
		exists = true,
		filename_is_not = {},
		filetype_is_not = {},
		modifiable = true,
	},
	write_all_buffers = false,
	on_off_commands = true,
	clean_command_line_interval = 0,
	debounce_delay = 500, -- in ms
})

--Map blankline
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Gitsigns
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})
