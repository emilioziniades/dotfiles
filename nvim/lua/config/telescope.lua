local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		layout_strategy = "vertical",
		layout_config = {
			height = 0.80,
			width = function(_, max_columns, _)
				return math.min(max_columns, 80)
			end,
		},
		mappings = {
			i = {
				["<esc>"] = actions.close,
			},
		},
	},
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")

local function find_dotfiles()
	local config_dir = vim.fn.stdpath("config")
	require("telescope.builtin").find_files({ cwd = config_dir })
end

vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)
vim.keymap.set("n", "<leader>fo", require("telescope.builtin").oldfiles)
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").current_buffer_fuzzy_find)
vim.keymap.set("n", "<leader>fc", require("telescope.builtin").colorscheme)
vim.keymap.set("n", "<leader>fe", require("telescope").extensions.file_browser.file_browser)
vim.keymap.set("n", "<leader>fd", find_dotfiles)
