vars = require("variables")

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
	use("junegunn/goyo.vim")
	-- use({ "fatih/vim-go", run = ":GoUpdateBinaries" })
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
