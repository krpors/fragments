require("pgen")
require("util")
require("spatialgrid")
require("state_particleplayer")
require("state_fragments")

globals = {
	gamefont = nil
}

image = love.graphics.newImage("logo.png")

mousePosition = { 0, 0 }

gamestate = StateFragments()

function love.load()
	local glyphs = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-=_+|/\\:;'\"<>,.?"
	globals.gameFont = love.graphics.newImageFont("font.png", glyphs, 2)
	love.graphics.setDefaultFilter("nearest", "nearest")
	-- love.mouse.setVisible(false)

	-- vec4 color = love.graphics.setColor().
	-- texture = the image itself being drawn
	-- texture_coords = normalized (0.0, 1.0) coords
	-- screen_coords =  not-normalized screen coords
	effect = love.graphics.newShader("shaders/boxblur.frag")
end

local t = 0
function love.update(dt)
	t = t + dt
	-- effect:send("time", t)
	gamestate:update(dt)
end


function love.draw()
	-- love.graphics.setShader()
	love.graphics.setShader(effect)
	love.graphics.draw(image, 20, 20)
	love.graphics.line(0, 0, 200, 100)
	gamestate:draw()

	-- LOOK AT THE PRETTY COLORS!

	-- love.graphics.rectangle('fill', 10,305,780,285)
end

function love.mousepressed(x, y, button, istouch, presses)
	print(string.format("Click on %d, %d", x, y))
	-- grid:placeObstacle(x, y)

	gamestate:mousePressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
	gamestate:mouseReleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
	mousePosition = { x, y }
	gamestate:mouseMoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
	gamestate:mouseWheelMoved(x, y)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'f1' then
		gamestate = StateParticlePlayer()
	elseif key == 'f2' then
		gamestate = StateFragments()
	elseif key == 'r' then
		status, message = love.graphics.validateShader(false, "shaders/boxblur.frag")
		print(status)
		print(message)
	end

	gamestate:keyPressed(key)
end

function love.keyreleased(key)
end
