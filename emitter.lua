require("util")

-- Particle is a single particle with properties. The behaviour is depending
-- on the particle's element.
Particle = {}
Particle.__index = Particle

function Particle:new()
	local self = setmetatable({}, Particle)

	self.life = 2
	self.size = 3
	self.element = nil
	self.x = 0
	self.y = 0
	self.prevx = 0
	self.prevy = 0
	self.dx = 0
	self.dy = 0
	self.color = { 1, 1, 0, 1 }

	return self
end

function Particle:__tostring()
	return string.format("Particle (%d, %d)", self.x, self.y)
end

function Particle:moveToPreviousPosition()
	self.x = self.prevx
	self.y = self.prevy
end

function Particle:moveInRandomDirection()
	self.x = self.x + love.math.random(-1, 1) * self.size
	self.y = self.y + love.math.random(-0.5, 1) * self.size
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

-- Adds a new particle to the table.
function Emitter:addNewParticle()
	local particle = Particle:new()
	particle.x = self.origin.x
	particle.y = self.origin.y
	particle.life = self.element.life
	particle.color = {1, 0, 0, love.math.random()}

	-- initialize the direction vectors first
	particle.dx = love.math.random(self.element.delta.x[1], self.element.delta.x[2])
	particle.dy = love.math.random(self.element.delta.y[1], self.element.delta.y[2])

	-- We need the particle element later on
	particle.element = self.element

	table.insert(self.particles, particle)
end

function Emitter:update(dt)
	-- If we are emitting particles (i.e. clicked and stuff), start appending
	-- new particles to the table.
	if self.emitting then
		self:addNewParticle()
		self:addNewParticle()
		self:addNewParticle()
	end

	-- Update every particle.
	for i, p in ipairs(self.particles) do
		-- first make sure we have the previous positions saved
		p.prevx = p.x
		p.prevy = p.y

		p.x = p.x + p.dx * dt
		p.y = p.y + p.dy * dt
		p.dy = p.dy + p.element.gravity

		-- Diminish the life by the time delta.
		p.life = p.life - dt

		-- Keep the particles inside the window.
		self:checkParticleBounds(p)
	end

	-- Remove dead particles:
	table.removeif(self.particles, function(p) return p.life <= 0 end)
end

-- Will check the particle bounds, and if the window edges are hit, invert
-- the delta's, when applicable.
function Emitter:checkParticleBounds(particle)
	-- Whether there is gravity or not, invert the dx of the particle.
	if particle.x <= 0 or particle.x >= love.graphics.getWidth() then
		particle.dx = -math.abs(particle.dx)
	end

	if particle.y <= 0 then
		if particle.element.gravity < 0 then
			particle.y = 0
		else
			particle.dy = math.abs(particle.dy)
		end
	end

	-- Check if the particle goes beyond the screen's height.
	if particle.y >= love.graphics.getHeight() then
		-- First 'clamp' the value to the maximum height.
		particle.y = love.graphics.getHeight() - particle.size

		-- If there is zero gravity, it should act like a gas. In that case
		-- invert the y axis at all times.
		if particle.element.gravity == 0 then
			particle.dy = -math.abs(particle.dy)
		else
			particle.y = love.graphics.getHeight() - particle.size
		end
	end
end

function Emitter:draw()
	for _, p in ipairs(self.particles) do
		love.graphics.setColor(self.element.color.cool)
		love.graphics.circle('fill', p.x, p.y, p.size)
	end
end
