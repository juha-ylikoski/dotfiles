hl.curve("my_bezier", { type = "bezier", points = { { 0.10, 0.9 }, { 0.1, 1.05 } } })

hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 2,
	bezier = "my_bezier",
	style = "slide",
})
