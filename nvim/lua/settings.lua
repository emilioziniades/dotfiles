local vars = require("variables")
local utils = require("utils")

-- theme (time dependent)
vim.g.tokyonight_dark_float = true
vim.cmd("colorscheme " .. vars.theme)
vim.o.background = vars.background

-- other settings

vim.g.mapleader = " "

vim.o.mouse = "a"
vim.opt.undofile = true
vim.o.wrap = true
vim.o.linebreak = true
vim.o.spell = false
vim.o.spelllang = "en_gb"
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.foldmethod = "expr"
vim.o.foldenable = false
-- vim.o.showmode = false
vim.o.showmode = true
vim.o.termguicolors = true

-- make current line number pop
utils.line_number_emphasize()

-- filetype specific settings
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.js", "*.jsx" },
	callback = function()
		vim.schedule(function()
			vim.api.nvim_set_option_value("tabstop", 2, { scope = "local" })
			vim.api.nvim_set_option_value("shiftwidth", 2, { scope = "local" })
		end)
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.mdx",
	callback = function()
		vim.schedule(function()
			vim.api.nvim_set_option_value("filetype", "markdown", { scope = "local" })
		end)
	end,
})

-- Highlight on yank
vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	group = "YankHighlight",
	callback = function()
		vim.highlight.on_yank()
	end,
})
