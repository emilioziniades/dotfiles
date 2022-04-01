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
		"css",
	},
})
vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
