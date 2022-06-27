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

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.keymap.set("n", "<leader>sr", "<cmd>write | edit | TSBufEnable highlight<cr>")
