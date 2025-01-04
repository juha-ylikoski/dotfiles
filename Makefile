current_dir = $(shell pwd)


install: ~/.config/hypr \
	~/.config/kitty \
	~/.config/mako \
	~/.config/swaylock \
	~/.config/waybar \
	~/.config/wlogout \
	~/.config/wofi \



~/.config/%:
	ln -s $(current_dir)/.config/$(shell basename $@) $@

