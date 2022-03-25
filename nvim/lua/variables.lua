local variables = {}
local t = os.date("*t")
if 5 < t.hour and t.hour < 17 then
	variables.background = "dark"
	variables.theme = "tokyonight"
	variables.lualinetheme = "auto"
else
	variables.background = "dark"
	variables.theme = "tokyonight"
	variables.lualinetheme = "auto"
end
return variables
