-- Highlight on yank
vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	group = "YankHighlight",
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- filetype specific actions

-- js or jsx
vim.api.nvim_create_augroup("JavascriptFile", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.js", "*.jsx" },
	group = "JavascriptFile",
	callback = function()
		vim.schedule(function()
			vim.api.nvim_set_option_value("tabstop", 2, { scope = "local" })
			vim.api.nvim_set_option_value("shiftwidth", 2, { scope = "local" })
		end)
	end,
})

-- mdx
vim.api.nvim_create_augroup("MarkdownXFile", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.mdx",
	group = "MarkdownXFile",
	callback = function()
		vim.schedule(function()
			vim.api.nvim_set_option_value("filetype", "markdown", { scope = "local" })
		end)
	end,
})
