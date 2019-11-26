require("class")
require("util")

StateParticlePlayer = class()

-- This state can be used to play around with the particle generator itself.
-- It should be different than the 'fluidfun' part.
function StateParticlePlayer:_init()
	self.paused = false
	self.generatorsEnabled = true

    self.generators = self.createGenerators()
    self.iterator = circular_iter(self.generators)

	self.currentGenerator = self.iterator()
	self.currentGenerator:init({0, 0})
end

--- Initializes the generators with different values.
function StateParticlePlayer:createGenerators()
	local generators = {}

	local one = ParticleGenerator()
	one.name = "Fire"
	one.continuous = true
	one.delta.x = { -20, 20 }
	one.delta.y = { -20, 20 }
	one.gravity = 0

	two = ParticleGenerator()
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

	third = ParticleGenerator()
	third.name = "Third one"
	third.continuous = true
	third.maxlife = 1
	third.delta.x = { -600, 600 }
	third.delta.y = { -10, 80 }
	third.gravity = 5
	third.colorfunction = function(lifepercentage)
		return { 1, 1, 0, 1 - lifepercentage }
	end

	fourth = ParticleGenerator()
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

	fifth = ParticleGenerator()
	fifth.name = "Da Last One"
	fifth.continuous = false
	fifth.maxlife = 3
	fifth.delta.x = { -20, 490 }
	fifth.delta.y = { -20, 10 }
	fifth.gravity = -9.8
	fifth.particleCount = 30
	fifth.maxradius = 2
	fifth.colorfunction = function(lifepercentage)
		return { lifepercentage, 0.5, lifepercentage, lifepercentage }
	end

	table.insert(generators, one)
	table.insert(generators, two)
	table.insert(generators, third)
	table.insert(generators, fourth)
	table.insert(generators, fifth)

	return generators
end


function StateParticlePlayer:mousePressed(x, y, button, istouch, presses)
end

function StateParticlePlayer:mouseReleased(x, y, button, istouch, presses)
end

function StateParticlePlayer:mouseMoved(x, y, dx, dy, istouch)
	self.currentGenerator.origin = {x, y}
end

function StateParticlePlayer:keyPressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'p' then
		paused = not paused
	elseif key == 's' then
		self.generatorsEnabled = not self.generatorsEnabled
	elseif key == ']' then
		self.currentGenerator = self.iterator()
		self.currentGenerator:init(mousePosition)
	end
end

function StateParticlePlayer:update(dt)
    if self.paused then
		return
	end

	if self.generatorsEnabled then
		self.currentGenerator:update(dt)
	end
end

function StateParticlePlayer:draw()
	if self.generatorsEnabled then
		self.currentGenerator:draw()
	end

	love.graphics.setFont(globals.gameFont)
	love.graphics.setColor(255, 255, 255)
    love.graphics.print("Current generator " .. self.currentGenerator.name, 0, 0)
end
