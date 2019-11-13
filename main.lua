require "pgen"
require "util"

paused = false

globals = {
	gamefont = nil
}

generators = {}
iterator = nil
currentGenerator = nil

mousePosition = { 0, 0 }

--- Initializes the generators with different values.
function initializeGenerators()
	local generators = {}

	one = ParticleGenerator:new()
	one.name = "Fire"
	one.continuous = true
	one.delta.x = { -20, 20 }
	one.delta.y = { -20, 20 }
	one.gravity = 0

	two = ParticleGenerator:new()
	two.name = "Firey Frank"
	two.continuous = true
	two.delta.x = { -100, 100 }
	two.delta.y = { -10, 80 }
	two.gravity = 2
	two.maxlife = 4
	two.colorfunction = function(lifepercentage)

		return {
			1,
			lifepercentage / 2,
			0,
			0.5
		}
	end

	third = ParticleGenerator:new()
	third.name = "Third one"
	third.continuous = true
	third.maxlife = 1
	third.delta.x = { -600, 600 }
	third.delta.y = { -10, 80 }
	third.gravity = 5
	third.colorfunction = function(lifepercentage)
		return { 1, 1, 0, 1 - lifepercentage }
	end

	fourth = ParticleGenerator:new()
	fourth.name = "Confetti!"
	fourth.continuous = true
	fourth.maxlife = 2
	fourth.delta.x = { -200, 200 }
	fourth.delta.y = { -10, 150 }
	fourth.gravity = 5
	fourth.colorfunction = function(lifepercentage)
		if lifepercentage < 0.5 then
			return {
				love.math.random(),
				love.math.random(),
				love.math.random(),
				love.math.random(),
			}
		end

		return { 1, 1, 1, 0.2}
	end


	table.insert(generators, one)
	table.insert(generators, two)
	table.insert(generators, third)
	table.insert(generators, fourth)

	return generators
end

function love.load()
	local glyphs = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-=_+|/\\:;'\"<>,.?"
	globals.gameFont = love.graphics.newImageFont("font.png", glyphs, 2)
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.mouse.setVisible(false)

	generators = initializeGenerators()
	iterator = circular_iter(generators)

	currentGenerator = iterator()
	currentGenerator:init({0, 0})
end

function love.update(dt)
	if paused then
		return
	end

	currentGenerator:update(dt)
end


function love.draw()
	currentGenerator:draw()

	love.graphics.setFont(globals.gameFont)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Current generator " .. currentGenerator.name, 0, 0)
end

function love.mousemoved(x, y, dx, dy, istouch)
	mousePosition = { x, y }
	currentGenerator.origin = { x, y }
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
	elseif key == ']' then
		currentGenerator = iterator()
		currentGenerator:init(mousePosition)
	end
end

function love.keyreleased(key)
end
