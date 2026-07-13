local waybar_scripts_dir = "~/.config/waybar/scripts"
local M = {
	terminal = 'alacritty --working-directory "$(hyprcwd)"',
	file_manager = "dolphin",
	menu = "wofi --show drun",
	lock = "hyprlock",
	screenshot = 'grim -g "$(slurp)" - | swappy -f -',
	waybar_scripts = {
		volume = function(arg)
			return hl.dsp.exec_cmd(waybar_scripts_dir .. "/volume " .. arg)
		end,
		kb_brightness = function(arg)
			return hl.dsp.exec_cmd(waybar_scripts_dir .. "/kb-brightness " .. arg)
		end,
		brightness = function(arg)
			return hl.dsp.exec_cmd(waybar_scripts_dir .. "/brightness " .. arg)
		end,
	},
}

return M
