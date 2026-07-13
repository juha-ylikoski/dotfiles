hl.config({
	general = {
		border_size = 2,
		gaps_in = 5,
		gaps_out = 0,
		col = { inactive_border = 0x595959aa, active_border = 0xcdd6f4 },
		layout = "dwindle",
		snap = { enabled = false },
	},
	dwindle = {
		preserve_split = true,
	},
	decoration = {
		rounding = 5,
		blur = {
			enabled = true,
			size = 7,
			passes = 4,
		},
	},
	animations = {
		-- TODO
	},
	input = {
		kb_layout = "fi",
		kb_variant = "nodeadkeys",
		kb_options = "ctrl:nocaps",
		follow_mouse = 1,
		touchpad = {
			natural_scroll = true,
		},
	},
	group = {
		merge_groups_on_drag = false,
		groupbar = {
			font_size = 10,
			stacked = false,
		},
	},
	misc = {
		vrr = 1,
		disable_hyprland_logo = true,
	},
})
