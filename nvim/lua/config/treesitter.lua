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
		"typescript",
		"tsx",
		"lua",
		"c_sharp",
		"css",
		"rust",
		"html",
		"toml",
	},
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.keymap.set("n", "<leader>sr", "<cmd>write | edit | TSBufEnable highlight<cr>")
