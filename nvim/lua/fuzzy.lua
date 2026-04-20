vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

local minipick = require("mini.pick")
minipick.setup({
	mappings = {
		move_down = "<C-j>",
		move_up = "<C-k>",
		choose_marked = "<C-y>",
	},
})

local miniextra = require("mini.extra")

vim.keymap.set("n", "<leader><space>", minipick.builtin.buffers)
vim.keymap.set("n", "<leader>ff", minipick.builtin.files)
vim.keymap.set("n", "<leader>fg", minipick.builtin.grep_live)
vim.keymap.set("n", "<leader>fh", minipick.builtin.help)
vim.keymap.set("n", "<leader>fo", miniextra.pickers.oldfiles)
vim.keymap.set("n", "<leader>fb", function()
	miniextra.pickers.buf_lines({ scope = "current" })
end)
vim.keymap.set("n", "<leader>fc", miniextra.pickers.colorschemes)
vim.keymap.set("n", "<leader>fe", function()
	local cwd = (vim.fn.expand("%:p:h"))
	miniextra.pickers.explorer({
		cwd = (vim.fn.isdirectory(cwd) == 1) and cwd or nil,
	})
end)
vim.keymap.set("n", "<leader>fp", miniextra.pickers.explorer)
