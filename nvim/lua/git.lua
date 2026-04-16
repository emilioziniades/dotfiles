vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/tpope/vim-fugitive",
})

require("mini.git").setup()

local minidiff = require("mini.diff")
minidiff.setup()

vim.keymap.set("n", "[c", function()
	minidiff.goto_hunk("prev", { wrap = true })
end)
vim.keymap.set("n", "]c", function()
	minidiff.goto_hunk("next", { wrap = true })
end)

vim.keymap.set("n", "<leader>g", "<cmd>Git<cr>")
