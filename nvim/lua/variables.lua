local variables  = {}
local t = os.date ("*t")
if (5 < t.hour and t.hour < 17)
   then
        variables.background = 'light'
        variables.theme = 'PaperColor'
        variables.lualinetheme = 'solarized'
    else 
        variables.background = 'dark'
        variables.theme = 'monokai'
        variables.lualinetheme = 'onedark'
end
return variables
