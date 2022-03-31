local variables = {}
local t = os.date("*t")
if 5 < t.hour and t.hour < 17 then
	variables.background = "light"
	variables.theme = "tokyonight"
	vim.g.tokyonight_style = "day"
	variables.lualinetheme = "auto"
else
	variables.background = "dark"
	variables.theme = "tokyonight"
	vim.g.tokyonight_style = "storm"
	variables.lualinetheme = "auto"
end
return variables
