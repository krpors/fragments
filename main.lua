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

canvas = nil
gamestate = StateFragments()

function love.load()
	local glyphs = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-=_+|/\\:;'\"<>,.?"
	globals.gameFont = love.graphics.newImageFont("font.png", glyphs, 2)

	love.graphics.setDefaultFilter("nearest", "nearest")
	-- love.mouse.setVisible(false)
	effect = love.graphics.newShader("shaders/boxblur.frag")
	-- effect = love.graphics.newShader("shaders/moonshine.frag")
	canvas = love.graphics.newCanvas(800, 600)
end

local t = 0
function love.update(dt)
	t = t + dt
	-- effect:send("time", t)
	gamestate:update(dt)
end


function love.draw()
	-- Draw everything to the canvas
	love.graphics.setCanvas(canvas)
	love.graphics.clear()
	love.graphics.setColor(1, 1, 1, 1)
	-- love.graphics.setShader(effect)
	-- love.graphics.draw(image, 20, 20)
	gamestate:draw()

	-- re-enable drawing to the main screen
	love.graphics.setCanvas()

	-- last but not least, draw the canvas to screen
	love.graphics.draw(canvas)
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
	elseif key == 'f' then
		love.window.setFullscreen(true, "desktop")
		canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
	elseif key == 'f1' then
		gamestate = StateParticlePlayer()
	elseif key == 'f2' then
		gamestate = StateFragments()
	elseif key == 'r' then
		status, message = love.graphics.validateShader(false, "shaders/boxblur.frag")
		print(status)
		print(message)
		if status then
			effect = love.graphics.newShader("shaders/boxblur.frag")
		end
	end

	gamestate:keyPressed(key)
end

function love.keyreleased(key)
end
