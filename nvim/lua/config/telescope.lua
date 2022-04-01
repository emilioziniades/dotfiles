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
		find_files = {
			theme = "dropdown",
		},
		buffers = {
			theme = "dropdown",
		},
		-- live_grep = {
		-- theme = "dropdown",
		-- },
		-- help_tags = {
		-- theme = "dropdown",
		-- },
		-- oldfiles = {
		-- theme = "dropdown",
		-- },
		current_buffer_fuzzy_find = {
			theme = "dropdown",
		},
	},
})
require("telescope").load_extension("fzf")
