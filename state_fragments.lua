require("emitter")
require("element")

StateFragments = {}
StateFragments.__index = StateFragments

local function createHydrogenEmitter()
	local e = Element:new()
	e.name = "Hydrogen"
	e.gravity = 0
	e.type = "gas"
	e.color = {
		cool = { 1, 1, 0, 1 },
		hot = { 1, 1, 1, 1 }
	}
	e.delta = {
		x = { -40, 40},
		y = { -40, 40},
	}
	e.life = 10

	local emitter = Emitter:new()
	emitter:setElement(e)
	return emitter
end

local function createWaterEmitter()
	local e = Element:new()
	e.name = "Water"
	e.gravity = 9
	e.delta = {
		x = { -10, 10},
		y = { 0, 80},
	}
	e.life = 10

	local emitter = Emitter:new()
	emitter:setElement(e)
	return emitter
end

local function createFireEmitter()
	local e = Element:new()
	e.name = "Fire"
	e.gravity = -9
	e.color = {
		cool = { 1, 0, 0, 1 },
		hot = { 1, 1, 1, 1 }
	}
	e.delta = {
		x = { -10, 10},
		y = { -40, 10},
	}
	e.life = 10

	local emitter = Emitter:new()
	emitter:setElement(e)
	return emitter
end

-- This is the actual Fragments implementation (fluidfun).
function StateFragments:new()
	local self = setmetatable({}, StateFragments)

	self.emitters = {}
	table.insert(self.emitters, createHydrogenEmitter())
	table.insert(self.emitters, createWaterEmitter())
	table.insert(self.emitters, createFireEmitter())

	self.nextEmitter = circular_iter(self.emitters)
	self.currentEmitter = self.nextEmitter()

	return self
end


function StateFragments:mousePressed(x, y, button, istouch, presses)
	self.currentEmitter:setEmitting(true)
end

function StateFragments:mouseReleased(x, y, button, istouch, presses)
	self.currentEmitter:setEmitting(false)
end

function StateFragments:mouseMoved(x, y, dx, dy, istouch)
	self.currentEmitter:emitAt(x, y)
end

function StateFragments:keyPressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == ']'  then
		self.currentEmitter = self.nextEmitter()
	end
end

function StateFragments:update(dt)
	self.currentEmitter:update(dt)

	for _, particle1 in ipairs(self.currentEmitter.particles) do
		for _, particle2 in ipairs(self.currentEmitter.particles) do
			if particle1 ~= particle2 then
				if particle1:collidesWith(particle2) then
					-- particle2:moveInRandomDirection()
					particle1:handleCollision(particle2)
					particle2:handleCollision(particle1)
				end
			end
		end
	end
end

function StateFragments:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Fragments", 0, 0)
	love.graphics.print("# of particles: " .. #self.currentEmitter.particles, 0, 10)
	local s = ""
	for _, p in ipairs(self.currentEmitter.particles) do
		s = s .. string.format("%s\n", p)
	end

	love.graphics.print(s, 0, 20)
	self.currentEmitter:draw()
end
