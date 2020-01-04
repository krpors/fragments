require("class")
require("util")

-- An emitter is actually just a container for generated particles. It is
-- responsible for creating them (via a generator function), updating them and
-- drawing them. Every update(), dead particles are removed from the backing
-- list.
--
-- The emitter itself is rather 'dumb': the logic of the actual particle
-- behaviour is done by the particles themselves
Emitter = class()

-- Creates a new emitter. The supplied `generator' is a function which returns
-- a new particle, for example:
--
-- 	Emitter(function() return HydrogenParticle:new() end)
function Emitter:_init(generator)
	self.particles = {}
	self.emitting = false
	self.generator = generator
	self.multiplier = 1
	self.particleTimer = 0
	-- if expires is set to true, the emitter has a lifetime. If false,
	-- the emitter will not stop emitting.
	self.expires = false
	-- The life of the emitter in seconds.
	self.life = 300
	-- World reference where this emitter is placed onto.
	self.world = nil
	-- The origin of the emitter:
	self.origin = {
		x = 0,
		y = 0,
	}
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
	-- Create a new particle from the generator function.
	local particle = self:generator()
	particle.world = self.world
	particle.x = self.origin.x
	particle.y = self.origin.y
	table.insert(self.particles, particle)
end

-- Returns true if the emitter is expired, meaning: the emitter is at its EOL,
-- and all particles in the emitter are gone as well.
function Emitter:isExpired()
	return #self.particles <= 0 and self.life <= 0
end

function Emitter:update(dt)
	self.particleTimer  = self.particleTimer + dt
	-- If we are emitting particles (i.e. clicked and stuff), start appending
	-- new particles to the table.
	if self.emitting and self.particleTimer >= 0.2 then
		self.particleTimer = 0

		-- only spawn new particles when the emitter is still alive.
		if self.life > 0 then
			self:addNewParticle()
		end
	end

	if self.expires then
		self.life = self.life - dt
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
