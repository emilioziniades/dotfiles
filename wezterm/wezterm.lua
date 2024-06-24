local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.enable_tab_bar = false
config.font = wezterm.font("MonaspiceNe Nerd Font", { weight = "Medium" })
config.default_prog = { "tmux" }

wezterm.on("format-window-title", function()
	return "WezTerm"
end)

return config
