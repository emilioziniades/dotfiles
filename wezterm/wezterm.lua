local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("MonaspiceNe Nerd Font", { weight = "Medium" })

config.enable_tab_bar = false

config.native_macos_fullscreen_mode = true

wezterm.on("format-window-title", function()
	return "WezTerm"
end)

return config
