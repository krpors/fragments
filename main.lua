require "pgen"

pgen = ParticleGenerator:new(200, 200)
paused = false

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.mouse.setVisible(false)
	pgen:init()
	pgen.continuous = true
end

function love.update(dt)
	if paused then
		return
	end

	pgen:update(dt)
end


function love.draw()
	pgen:draw()
end

function love.mousemoved(x, y, dx, dy, istouch)
	pgen.pos.x = x
	pgen.pos.y = y
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'x' then
		pgen:init()
	elseif key == 'p' then
		paused = not paused
	elseif key == 'f' then
		local fs = love.window.getFullscreen()
		love.window.setFullscreen(not fs)
	end
end

function love.keyreleased(key)
end
