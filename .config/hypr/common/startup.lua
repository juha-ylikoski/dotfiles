hl.on("hyprland.start", function()
	for _, cmd in ipairs({
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
		"systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
		"/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
		'gsettings set org.gnome.desktop.interface gtk-theme "Adwaita:dark"', -- for GTK3 apps
		'gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"', -- for GTK4 apps
		"waybar",
		"mako",
		"blueman-applet",
		"nm-applet --indicator",
		"hypridle",
	}) do
		hl.exec_cmd(cmd)
	end
end)
