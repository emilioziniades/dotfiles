-- These are all the mini-nvim plugins that are so small they don't really
-- need their own file, or didn't logically belong in their own file. Each of
-- those files represents a category of functionality. I could split these into
-- 'appearance' and 'behaviour' but those feel too broad
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- bracket add/delete/replace
require("mini.surround").setup({
	n_lines = 100,
})

--automatic brackets
require("mini.pairs").setup()

-- commenting
require("mini.comment").setup()

-- icons
require("mini.icons").setup()

-- bracket add/delete/replace
require("mini.surround").setup({
	n_lines = 100,
})

--automatic brackets
require("mini.pairs").setup()

-- commenting
require("mini.comment").setup()

-- show indents
local miniindentscope = require("mini.indentscope")
miniindentscope.setup({
	draw = {
		delay = 0,
		animation = miniindentscope.gen_animation.none(),
	},
})

-- highlight todo comments
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

		-- Highlight hex color strings (`#rrggbb`) using that color
		hex_color = hipatterns.gen_highlighter.hex_color(),
	},
})
