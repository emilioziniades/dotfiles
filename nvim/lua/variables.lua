local variables = {}
local t = os.date("*t")
if 5 < t.hour and t.hour < 17 then
	variables.theme = "tokyonight"
	variables.background = "dark"
	vim.g.tokyonight_style = "storm"
	-- variables.background = "light"
	-- vim.g.tokyonight_style = "day"
	variables.lualinetheme = "auto"
else
	variables.theme = "tokyonight"
	variables.background = "dark"
	vim.g.tokyonight_style = "storm"
	variables.lualinetheme = "auto"
end
return variables
