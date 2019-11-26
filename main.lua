require "pgen"
require "util"
require "grid"
require "state_particleplayer"
require "state_fragments"

globals = {
	gamefont = nil
}

mousePosition = { 0, 0 }

gamestate = StateFragments()

grid = Grid:new()

function love.load()
	local glyphs = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-=_+|/\\:;'\"<>,.?"
	globals.gameFont = love.graphics.newImageFont("font.png", glyphs, 2)
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.mouse.setVisible(false)

	effect = love.graphics.newShader([[
		vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
			vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
			return vec4(0,0,1,0.5);
		  }
    ]])
end

local t = 0
function love.update(dt)
	gamestate:update(dt)
end


function love.draw()
	grid:draw()

	love.graphics.setShader()
	gamestate:draw()

	-- LOOK AT THE PRETTY COLORS!
	-- love.graphics.setShader(effect)
	-- love.graphics.rectangle('fill', 10,305,780,285))
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
	grid.mousePosition = { x, y }

	gamestate:mouseMoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
	if y > 0 then
		grid.gridSize = grid.gridSize + 1
	elseif y < 0 then
		grid.gridSize = grid.gridSize - 1
		-- amdgpu: The CS has been canceled because the context was lost
		if grid.gridSize <= 0 then
			grid.gridSize = 1
		end
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'f1' then
		gamestate = StateParticlePlayer()
	elseif key == 'f2' then
		gamestate = StateFragments()
	end

	gamestate:keyPressed(key)
end

function love.keyreleased(key)
end
