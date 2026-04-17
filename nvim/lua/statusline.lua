vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

require("mini.diff").setup()
require("mini.git").setup()
local statusline = require("mini.statusline")

statusline.setup({
	use_icons = false,
})
