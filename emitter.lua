require("util")
require("particle")

-- An emitter is just that: an emitter of particles. The emitter can be placed
-- on the grid to emit particles of a certain element type. The emitter contains
-- all the emitted particles as a list.
Emitter = {}
Emitter.__index = Emitter

function Emitter:new()
	local self = setmetatable({}, Emitter)
	self.particles = {}
	self.emitting = false
	-- The origin of the emitter:
	self.origin = {
		x = 0,
		y = 0,
	}
	return self
end

function Emitter:setElement(e)
	self.element = e
end

function Emitter:setEmitting(bool)
	self.emitting = bool
end

function Emitter:emitAt(x, y)
	self.origin = {
		x = x,
		y = y
	}
end

-- Adds a new particle to the table.
function Emitter:addNewParticle()
	-- Create a new particle, derived from properties of the element.
	local particle = Particle:new(self.element)
	particle.x = self.origin.x
	particle.y = self.origin.y
	table.insert(self.particles, particle)
end

function Emitter:update(dt)
	-- If we are emitting particles (i.e. clicked and stuff), start appending
	-- new particles to the table.
	if self.emitting then
		self:addNewParticle()
	end

	-- Update every particle.
	for i, p in ipairs(self.particles) do
		p:update(dt)
	end

	-- Remove dead particles:
	table.removeif(self.particles, function(p) return p.life <= 0 end)
end

function Emitter:draw()
	for _, p in ipairs(self.particles) do
		p:draw()
	end
end
