local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<esc>"] = actions.close,
			},
		},
	},
	pickers = {
		-- find_files = {
		-- 	theme = "dropdown",
		-- },
		-- buffers = {
		-- 	theme = "dropdown",
		-- },
		-- live_grep = {
		-- theme = "dropdown",
		-- },
		-- help_tags = {
		-- theme = "dropdown",
		-- },
		-- oldfiles = {
		-- theme = "dropdown",
		-- },
		-- current_buffer_fuzzy_find = {
		-- 	theme = "dropdown",
		-- },
	},
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")

vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)
vim.keymap.set("n", "<leader>fo", require("telescope.builtin").oldfiles)
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").current_buffer_fuzzy_find)
vim.keymap.set("n", "<leader>fc", require("telescope.builtin").colorscheme)
vim.keymap.set("n", "<leader>fe", require("telescope").extensions.file_browser.file_browser)
