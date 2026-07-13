hl.window_rule({
	name = "idle_inhibit_video",
	match = {
		content = "video",
	},
	idle_inhibit = "always",
})

hl.window_rule({
	name = "idle_inhibit_game",
	match = {
		content = "game",
	},
	idle_inhibit = "always",
})
