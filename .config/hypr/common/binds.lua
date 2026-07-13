local vars = require("common/vars")

-- Bring the workspace to the focused monitor and switch to it;
-- pressing the bind for the already-active workspace toggles back
-- to the previous one.
local function open_workspace_on_current_monitor(workspace)
	return function()
		local active = hl.get_active_workspace()
		if active ~= nil and active.id == workspace then
			hl.dispatch(hl.dsp.focus({ workspace = "previous" }))
			return
		end
		local monitor = hl.get_active_monitor()
		hl.dispatch(hl.dsp.workspace.move({ workspace = workspace, monitor = monitor.name }))
		hl.dispatch(hl.dsp.focus({ workspace = workspace }))
	end
end

hl.bind("SUPER + Q", hl.dsp.exec_cmd(vars["terminal"]))
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd(vars["lock"]))
hl.bind("SUPER + E", hl.dsp.exec_cmd(vars["file_manager"]))
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + R", hl.dsp.exec_cmd(vars["menu"]))
hl.bind("SUPER + N", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + S", hl.dsp.exec_cmd(vars["screenshot"]))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind("SUPER + G", hl.dsp.group.toggle())
hl.bind("ALT + TAB", hl.dsp.group.next())
hl.bind("ALT + SHIFT + TAB", hl.dsp.group.prev())

hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))

for workspace, key in ipairs({
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"0",
	"CTRL + 1",
	"CTRL + 2",
	"CTRL + 3",
	"CTRL + 4",
	"CTRL + 5",
	"CTRL + 6",
	"CTRL + 7",
	"CTRL + 8",
	"CTRL + 9",
	"CTRL + 0",
}) do
	hl.bind("SUPER +" .. key, hl.dsp.focus({ workspace = workspace }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
	hl.bind("SUPER + ALT + " .. key, open_workspace_on_current_monitor(workspace))
end

-- Scroll through existing workspaces with SUPER + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("SUPER + SHIFT + L", hl.dsp.window.resize({ x = 10, y = 0 }))
hl.bind("SUPER + SHIFT + H", hl.dsp.window.resize({ x = -10, y = 0 }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.resize({ x = 0, y = -10 }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.resize({ x = 0, y = 10 }))

-- Media binds
local script = vars["waybar_scripts"]
local volume = script["volume"]
local kb_brightness = script["kb_brightness"]
local brightness = script["brightness"]

hl.bind("xf86audioraisevolume", volume("--inc"))
hl.bind("xf86audiolowervolume", volume("--dec"))
hl.bind("xf86AudioMicMute", volume("--toggle-mic"))
hl.bind("xf86audioMute", volume("--toggle"))

hl.bind("xf86KbdBrightnessDown", kb_brightness("--dec"))
hl.bind("xf86KbdBrightnessUp", kb_brightness("--inc"))

hl.bind("xf86MonBrightnessDown", brightness("--dec"))
hl.bind("xf86MonBrightnessUp", brightness("--inc"))
