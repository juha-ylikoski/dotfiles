-- Left secondary monitor
hl.monitor({
	output = "HDMI-A-1",
	mode = "preferred",
	position = "auto-left",
	scale = 1,
})

-- Main monitor
hl.monitor({
	output = "DP-2",
	mode = "highrr",
	position = "0x0",
	scale = 1,
})

-- Right secondary monitor
hl.monitor({
	output = "DP-3",
	mode = "preferred",
	position = "auto-right",
	scale = 1,
	transform = 3,
})

-- hl.config({
-- 	xwayland = {
-- 		force_zero_scaling = true
-- 	}
-- })

require("nvidia/env")
