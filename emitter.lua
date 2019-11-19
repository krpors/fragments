-- Particle is a single particle with properties. The behaviour is depending
-- on the particle's element.
Particle = {}
Particle.__index = Particle

function Particle:new()
	local self = setmetatable({}, Particle)

	-- Life in seconds!
	self.life = 2
	self.size = 2
	self.pos = {
		x = 0,
		y = 0,
	}

	return self
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
	if self.emitting then
		-- add particles while we are emitting.
		local particle = Particle:new()
		particle.pos.x = self.origin.x
		particle.pos.y = self.origin.y
		table.insert(self.particles, particle)
	end

	-- update every particle
	for i, k in ipairs(self.particles) do
		k.pos.x = k.pos.x + love.math.random() * dt * 150
		k.pos.y = k.pos.y + love.math.random() * dt * 150
		k.life = k.life - dt

		-- If a particle dies, remove it from the particles list/table.
		if k.life <= 0 then
			table.remove(self.particles, i)
		end
	end
end

function Emitter:draw()
	love.graphics.setPointSize(4)
	for i, k in ipairs(self.particles) do
		-- print(k)
		love.graphics.points(k.pos.x, k.pos.y)
	end
end
