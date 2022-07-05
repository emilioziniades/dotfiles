local variables = {}
local t = os.date("*t")
if 5 < t.hour and t.hour < 17 then
	variables.theme = "sonokai"
	variables.background = "dark"
	variables.lualinetheme = "auto"
else
	variables.theme = "sonokai"
	variables.background = "dark"
	variables.lualinetheme = "auto"
end
return variables
