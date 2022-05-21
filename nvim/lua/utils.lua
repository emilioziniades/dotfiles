local M = {}

M.I = function(item)
	print(vim.inspect(item))
end

function M.toggle_relative_line_numbers()
	if vim.o.relativenumber then
		vim.o.relativenumber = false
	else
		vim.o.relativenumber = true
	end
end

function M.line_number_emphasize()
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

function M.toggle_theme_background()
	local colorscheme = vim.cmd("silent colorscheme")
	if vim.o.background == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
	vim.cmd("silent colorscheme " .. colorscheme)
	M.line_number_emphasize()
end

function M.count_words()
	if vim.fn.wordcount().visual_words == 1 then
		print(vim.fn.wordcount().visual_words .. " word selected")
	elseif not (vim.fn.wordcount().visual_words == nil) then
		print(vim.fn.wordcount().visual_words .. " words selected")
	else
		print(vim.fn.wordcount().words .. " words")
	end
end

function M.run_file()
	if vim.bo.filetype == "python" then
		vim.cmd([[! echo \\n &&  python "%"]])
	else
		if vim.bo.filetype == "go" then
			vim.cmd("!go run %")
		end
	end
end

function M.run_file_repl()
    require("iron").core.send(vim.bo.ft, vim.fn.readfile(vim.fn.expand("%")))
end

function M.start_repl()
    require("iron.core").repl_for(vim.bo.ft)
end
return M
