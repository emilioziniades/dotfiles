vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("ManualFold", { clear = true }),
	command = "normal zx | zi",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.js", "*.jsx", "*.html", "*.ts", "*.tsx" },
	group = vim.api.nvim_create_augroup("JavascriptFile", { clear = true }),
	callback = function()
		vim.schedule(function()
			vim.api.nvim_set_option_value("tabstop", 2, { scope = "local" })
			vim.api.nvim_set_option_value("shiftwidth", 2, { scope = "local" })
		end)
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.mdx",
	group = vim.api.nvim_create_augroup("MarkdownXFile", { clear = true }),
	callback = function()
		vim.schedule(function()
			vim.api.nvim_set_option_value("filetype", "markdown", { scope = "local" })
		end)
	end,
})
