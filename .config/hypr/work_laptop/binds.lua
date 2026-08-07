local open_workspace_on_current_monitor = require("common.macros")["open_workspace_on_current_monitor"]

hl.bind("SUPER + T", open_workspace_on_current_monitor("name:teams"))
hl.bind("SUPER + SHIFT + M", open_workspace_on_current_monitor("name:thunderbird"))

hl.workspace_rule({
	workspace = "name:teams",
	on_created_empty = "flatpak run com.github.IsmaelMartinez.teams_for_linux",
})
hl.workspace_rule({ workspace = "name:thunderbird", on_created_empty = "thunderbird" })

hl.bind("switch:on:Lid Switch", function()
	hl.monitor({
		output = "desc:BOE 0x0A35",
		disabled = true,
	})
end, { locked = true })

hl.bind("switch:off:Lid Switch", function()
	hl.monitor({
		output = "desc:BOE 0x0A35",
		mode = "1920x1200@60",
		position = "auto-left",
		scale = 1,
		disabled = false,
	})
end, { locked = true })
