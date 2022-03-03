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
	use("neovim/nvim-lspconfig")
	--functionality
	use({ "jose-elias-alvarez/null-ls.nvim", requires = { "nvim-lua/plenary.nvim" } })
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("p00f/nvim-ts-rainbow")
	use("kyazdani42/nvim-tree.lua")
	use("kyazdani42/nvim-web-devicons")
	use("nvim-lualine/lualine.nvim")
	use("numToStr/Comment.nvim")
	use("numToStr/FTerm.nvim")
	use("junegunn/goyo.vim")
	use({ "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } })
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("vim-scripts/auto-pairs-gentle")
	use("machakann/vim-sandwich")
	use("Pocco81/AutoSave.nvim")
	--themes
	use("tanvirtin/monokai.nvim")
	use("Mofiqul/dracula.nvim")
	use("sjl/badwolf")
	use("folke/tokyonight.nvim")
	use({ "rose-pine/neovim", as = "rose-pine" })
end)

-- nvim-tree configuration
require("nvim-tree").setup()

--lualine configuration
require("lualine").setup({
	options = { theme = vars.lualinetheme },
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
