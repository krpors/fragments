function love.conf(t)
	t.version = "11.3"
	t.modules.joystick = false
	t.modules.physics = false
	t.modules.mouse = true

	t.window.width = 1024
	t.window.height = 768
	t.window.title = "Fragments"
	t.window.fsaa = 2
	t.window.msaa = 2
end
