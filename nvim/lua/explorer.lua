vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-mini/mini.nvim",
})

require("mini.icons").setup()

require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})

vim.keymap.set("n", "-", "<cmd>Oil<cr>")
