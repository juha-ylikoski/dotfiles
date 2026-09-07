-- Returns true if a connected monitor's description contains `needle`.
-- Note: HL.Monitor.description has NO "desc:" prefix, so we substring-match.
local function connected(needle)
	for _, mon in ipairs(hl.get_monitors()) do
		if mon.description and mon.description:find(needle, 1, true) then
			return true
		end
	end
	return false
end

-- Office = both the Acer main monitor AND the Samsung right secondary present.
local function at_office()
	return connected("Acer Technologies EB321HQU T5NEE0083E00") and connected("SAMSUNG 0x00000001")
end

local function at_home()
	return connected("Acer Technologies XB271HU T4TEE0028502") and connected("Samsung Electric Company T23C350")
end

-- Current monitor setup as a string enum: "office" | "home" | "laptop".
local function current_setup()
	if at_office() then
		return "office"
	elseif at_home() then
		return "home"
	else
		return "laptop"
	end
end

-- Write the current setup to a file waybar can read, then poke waybar to
-- refresh the module instantly (SIGRTMIN+8, matched in waybar config).
local function write_setup()
	local f = io.open("/tmp/hyprland-monitors", "w")
	if f then
		f:write(current_setup(), "\n")
		f:close()
	end
	hl.exec_cmd("pkill -RTMIN+8 waybar")
end

-- ── Laptop mirroring (for presenting) ──────────────────────────────────────
-- The waybar toggle only writes "on"/"off" to this file; Hyprland reads it and
-- does the actual monitor changes (no `hyprctl reload`, which would drop the
-- mirror). `applied_mirror` tracks the last state we applied so we only
-- reconfigure monitors on a real change (no flicker on every poll tick).
local MIRROR_FILE = "/tmp/hyprland-mirror"
local applied_mirror = nil

local function read_mirror()
	local f = io.open(MIRROR_FILE, "r")
	if not f then
		return "off"
	end
	local s = (f:read("l") or ""):gsub("%s", "")
	f:close()
	return s == "on" and "on" or "off"
end

local function write_mirror(state)
	local f = io.open(MIRROR_FILE, "w")
	if f then
		f:write(state, "\n")
		f:close()
	end
	hl.exec_cmd("pkill -RTMIN+9 waybar")
end

-- Output names we've put into mirror mode. A mirroring output DROPS OUT of
-- hl.get_monitors(), so we can't rediscover it to turn mirroring back off --
-- we remember its (stable) output name here instead.
local mirrored = {}

-- Returns the laptop monitor and the list of external output NAMES to act on:
-- every currently-connected non-laptop output, plus any we previously put into
-- mirror mode (now hidden from get_monitors), plus -- defensively -- whatever
-- the laptop reports it is being mirrored by.
local function laptop_and_externals()
	local laptop, names, seen = nil, {}, {}
	local function add(name)
		if name and not seen[name] then
			seen[name] = true
			names[#names + 1] = name
		end
	end
	for _, mon in ipairs(hl.get_monitors()) do
		if mon.description and mon.description:find("BOE 0x0A35", 1, true) then
			laptop = mon
		else
			add(mon.name)
		end
	end
	for name in pairs(mirrored) do
		add(name)
	end
	if laptop then
		local m = laptop.mirrors
		if type(m) == "table" then
			if m.name then
				add(m.name) -- single monitor
			else
				for _, mon in ipairs(m) do
					add(mon.name)
				end
			end
		end
	end
	return laptop, names
end

-- Point every external at the laptop (mirror on) or back to extend (off).
-- To turn mirroring OFF we set `mirror` to a name that resolves to no monitor
-- ("none"): Hyprland's setMirror() takes the "disable" branch whenever the
-- target doesn't resolve, which reliably clears the mirror across versions.
local function apply_mirror(state)
	local laptop, externals = laptop_and_externals()
	if not laptop then
		return -- nothing to mirror from (e.g. lid closed)
	end
	for _, name in ipairs(externals) do
		if state == "on" then
			hl.monitor({
				output = name,
				mode = "preferred",
				position = "auto",
				scale = 1,
				mirror = laptop.name,
			})
			mirrored[name] = true
		else
			hl.monitor({
				output = name,
				mode = "preferred",
				position = "auto-right",
				scale = 1,
				mirror = "none",
			})
			mirrored[name] = nil
		end
	end
	applied_mirror = state
end

local function apply_monitors()
	-- Laptop monitor (always present)
	hl.monitor({
		output = "desc:BOE 0x0A35",
		mode = "1920x1200@60",
		position = "auto-left",
		scale = 1,
	})

	if at_office() then
		-- Main monitor
		hl.monitor({
			output = "desc:Acer Technologies EB321HQU T5NEE0083E00",
			mode = "preferred",
			position = "0x0",
			scale = 1,
		})

		-- Right secondary monitor
		hl.monitor({
			output = "desc:Samsung Electric Company SAMSUNG 0x00000001",
			mode = "preferred",
			position = "auto-right",
			scale = 1,
			transform = 1,
		})
		-- Laptop monitor (always present)
		hl.monitor({
			output = "desc:BOE 0x0A35",
			mode = "1920x1200@60",
			position = "auto-left",
			scale = 1,
			disabled = false,
		})
	elseif at_home() then
		-- Home screens
		hl.monitor({
			output = "desc:Samsung Electric Company T23C350",
			mode = "preferred",
			position = "auto-left",
			scale = 1,
		})
		hl.monitor({
			output = "desc:Acer Technologies XB271HU T4TEE0028502",
			mode = "preferred",
			position = "auto-right",
			scale = 1,
		})
		hl.monitor({
			output = "desc:BOE 0x0A35",
			disabled = true,
		})
	else
		hl.monitor({
			output = "desc:BOE 0x0A35",
			mode = "1920x1200@60",
			position = "auto-left",
			scale = 1,
			disabled = false,
		})
	end
end

local function apply_and_report()
	apply_monitors()
	write_setup()
	-- Mirroring only applies in the "laptop" (presenting) setup; office/home
	-- own their externals explicitly, so force the mirror state off there.
	if current_setup() == "laptop" then
		apply_mirror(read_mirror())
	else
		write_mirror("off")
		applied_mirror = "off"
	end
end

apply_and_report()

-- Re-run detection on dock/undock so it switches layouts live.
hl.on("monitor.added", apply_and_report)
hl.on("monitor.removed", apply_and_report)

hl.dsp.exec_cmd("echo start | tee /tmp/counter")

-- Poll the mirror-state file so the waybar toggle takes effect on demand
-- (toggling doesn't fire a monitor event). Only reconfigures on a real change.
local mirror_timer = hl.timer(function()
	if current_setup() ~= "laptop" then
		return
	end
	local want = read_mirror()
	if want ~= applied_mirror then
		apply_mirror(want)
	end
end, { timeout = 1000, type = "repeat" })
mirror_timer:set_enabled(true)

require("work_laptop.binds")
