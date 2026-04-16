vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
})

local minisnippets = require("mini.snippets")

minisnippets.setup({
	snippets = {
		minisnippets.gen_loader.from_lang(),
		function(context)
			if context.lang == "python" then
				return { { prefix = "bp", body = "breakpoint()", desc = "Python breakpoint" } }
			end
			return {}
		end,
	},
})
