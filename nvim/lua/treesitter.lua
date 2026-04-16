vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

local treesitter = require("nvim-treesitter")
treesitter.install({
	"bash",
	"cooklang",
	"c_sharp",
	"css",
	"dockerfile",
	"elixir",
	"fennel",
	"fsharp",
	"go",
	"groovy",
	"haskell",
	"hcl",
	"helm",
	"html",
	"htmldjango",
	"javascript",
	"json",
	"just",
	"lua",
	"markdown",
	"markdown_inline",
	"nix",
	"python",
	"rust",
	"scheme",
	"sql",
	"terraform",
	"toml",
	"tsx",
	"tsx",
	"typescript",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
})

-- enable folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- enable highlighting
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		local bufnr = args.buf
		local filetype = args.match
		local parser = vim.treesitter.language.get_lang(filetype)
		local installed_parsers = treesitter.get_installed()
		if vim.list_contains(installed_parsers, parser) then
			vim.treesitter.start(bufnr)
		end
	end,
})
