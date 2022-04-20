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

utils.count_words = function()
	if vim.fn.wordcount().visual_words == 1 then
		print(vim.fn.wordcount().visual_words .. " word selected")
	elseif not (vim.fn.wordcount().visual_words == nil) then
		print(vim.fn.wordcount().visual_words .. " words selected")
	else
		print(vim.fn.wordcount().words .. " words")
	end
end

utils.start_repl = function()
	if vim.bo.filetype == "python" then
		vim.cmd("vsplit | terminal ipython -i % ")
	end
end

utils.run_file = function()
	if vim.bo.filetype == "python" then
		vim.cmd("!python %")
	else
		if vim.bo.filetype == "go" then
			vim.cmd("!go run %")
		end
	end
end

return utils
