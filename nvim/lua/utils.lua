local utils = {}

utils.I = function(item)
	print(vim.inspect(item))
end

utils.toggle_relative_line_numbers = function()
	if vim.o.relativenumber then
		vim.o.relativenumber = false
	else
		vim.o.relativenumber = true
	end
end

utils.line_number_emphasize = function()
	local line_num_colour
	if vim.o.background == "light" then
		line_num_colour = "Black"
	else
		line_num_colour = "White"
	end
	vim.o.cursorline = true
	vim.cmd("hi Cursorline guibg=none")
	vim.cmd("hi CursorLineNr term=bold ctermfg=" .. line_num_colour .. " gui=bold guifg=" .. line_num_colour)
end

utils.toggle_theme_background = function()
	local colorscheme = vim.cmd("silent colorscheme")
	if vim.o.background == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
	vim.cmd("silent colorscheme " .. colorscheme)
	utils.line_number_emphasize()
end

return utils
