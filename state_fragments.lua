require("emitter")
require("element")

StateFragments = {}
StateFragments.__index = StateFragments

-- This is the actual Fragments implementation (fluidfun).
function StateFragments:new()
	local self = setmetatable({}, StateFragments)

	local hydrogen = Element:new()
	hydrogen.name = "Hydrogen"
	hydrogen.mass = 1
	hydrogen.type = "gas"
	hydrogen.delta = {
		x = { -50, 50},
		y = { -2, 100},
	}
	hydrogen.life = 100

	self.emitter = Emitter:new()
	self.emitter:setElement(hydrogen)

	return self
end


function StateFragments:mousePressed(x, y, button, istouch, presses)
	self.emitter:setEmitting(true)
end

function StateFragments:mouseReleased(x, y, button, istouch, presses)
	self.emitter:setEmitting(false)
end

function StateFragments:mouseMoved(x, y, dx, dy, istouch)
	self.emitter:emitAt(x, y)
end

function StateFragments:keyPressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function StateFragments:update(dt)
	self.emitter:update(dt)

	for _, particle1 in ipairs(self.emitter.particles) do
		for _, particle2 in ipairs(self.emitter.particles) do
			if particle1 ~= particle2 then
				if particle1:collidesWith(particle2) then
					particle2.x = particle2.prevx
					particle2.y = particle2.prevy
				end
			end
		end
	end
end

function StateFragments:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Fragments", 0, 0)
	love.graphics.print("# of particles: " .. #self.emitter.particles, 0, 10)

	self.emitter:draw()
end
