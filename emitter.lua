-- Particle is a single particle with properties. The behaviour is depending
-- on the particle's element.
Particle = {}
Particle.__index = Particle

function Particle:new()
	local self = setmetatable({}, Particle)

	self.life = 2
	self.size = 8
	self.element = nil
	self.x = 0
	self.y = 0
	self.prevx = 0
	self.prevy = 0

	return self
end

function Particle:__tostring()
	return string.format("Particle (%d, %d)", self.x, self.y)
end

-- Returns true when this particle collides with another particle
function Particle:collidesWith(otherParticle)
	-- just do a simple bounding box collision detection
	return
		    self.x < otherParticle.x + otherParticle.size
		and otherParticle.x < self.x + self.size
		and self.y < otherParticle.y + otherParticle.size
		and otherParticle.y < self.y + self.size
end

-- An emitter is just that: an emitter of particles. The emitter can be placed
-- on the grid to emit particles of a certain element type. The emitter contains
-- the logic on what to do when the particle dies.
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

function Emitter:update(dt)
	-- If we are emitting particles (i.e. clicked and stuff), start appending
	-- new particles to the table.
	if self.emitting then
		-- add particles while we are emitting.
		local particle = Particle:new()
		particle.x = self.origin.x
		particle.y = self.origin.y
		particle.life = self.element.life
		-- We need the particle element later on
		particle.element = self.element
		table.insert(self.particles, particle)
	end

	-- Update every particle.
	for i, p in ipairs(self.particles) do
		-- first make sure we have the previous positions saved
		p.prevx = p.x
		p.prevy = p.y

		local dx = love.math.random(self.element.delta.x[1], self.element.delta.x[2])
		local dy = love.math.random(self.element.delta.y[1], self.element.delta.y[2])

		p.x = p.x + dx * dt
		p.y = p.y + dy * dt
		p.life = p.life - dt

		-- If a particle dies, remove it from the particles list/table.
		if p.life <= 0 then
			table.remove(self.particles, i)
		end

		if p.y + p.size >= love.graphics.getHeight() then
			p.y = love.graphics.getHeight() - p.size
		end
	end
end

function Emitter:draw()
	for _, p in ipairs(self.particles) do
		love.graphics.rectangle('fill', p.x, p.y, p.size, p.size)
	end
end
