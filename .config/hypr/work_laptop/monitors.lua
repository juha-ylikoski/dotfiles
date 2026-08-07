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
	else
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
	end
end

apply_monitors()

-- Re-run detection on dock/undock so it switches layouts live.
hl.on("monitor.added", apply_monitors)
hl.on("monitor.removed", apply_monitors)

require("work_laptop.binds")
