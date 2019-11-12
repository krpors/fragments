ParticleGenerator = {}
ParticleGenerator.__index = ParticleGenerator

function ParticleGenerator:new(origin_x, origin_y)
	local self = setmetatable({}, ParticleGenerator)

	-- Spawn point, or just the origin of the generator
	self.pos = {
		x = origin_x,
		y = origin_y
	}

	-- Set to true to loop the generator.
	self.continuous = false
	self.color = {1, 0, 0, 1}
	self.particles = {}
	self.particleCount = 1000

	return self
end

--[[
-- Initializes the particle generator with all the parameters involved. This will
-- re-create the particles table (with zero particles), then initializes all particles
-- with the given properties.
--]]
function ParticleGenerator:init()
	self.particles = {}

	for i = 1, self.particleCount do
		local maxlife = love.math.random() * 2
		local p = {}
		self:resetParticle(p)

		table.insert(self.particles, p)
	end
end

--[[
-- Resets a particle's parameters.
--]]
function ParticleGenerator:resetParticle(p)
	local maxlife = love.math.random() * 3
	p.x         = self.pos.x
	p.y         = self.pos.y
	p.color     = self.color
	p.radius    = 8
	p.maxradius = 8
	p.dx        = love.math.random(-80, 80)
	p.dy        = love.math.random(-5, 100)
	p.life      = maxlife -- life in seconds
	p.maxlife   = maxlife -- life maximum
end

--[[
-- Updates the particle generator's particle positions, color, radius and whatever,
-- every frame.
--]]
function ParticleGenerator:update(dt)
	for k, p in ipairs(self.particles) do
		if p and p.life >= 0 then
			local lifepercentage = p.life / p.maxlife

			p.x = p.x + p.dx * dt
			p.y = p.y + p.dy * dt
			p.dy = p.dy - 5

			p.color = {
				1,
				1 - lifepercentage,
				0,
				0.7
			}

			p.life = p.life - dt
			-- Change the radius. The radius must decline to zero in proportion
			-- to the lifetime of the particle. Meaning, if the lifetime of the
			-- particle is 4.8 seconds, after 4.8 seconds we must have reached
			-- a radius of 0. We do that by just setting by calculating the
			-- percentage of the lifetime, multiplied by the original max radius.
			p.radius = p.maxradius * (p.life / p.maxlife)
		elseif p.life < 0 and self.continuous then
			-- If we need to emit continuously, reset the particle.
			self:resetParticle(p)
		end
	end
end

function ParticleGenerator:draw()
	for k, p in ipairs(self.particles) do
		if p and p.life > 0 then
			love.graphics.setColor(p.color)
			love.graphics.circle('fill', p.x, p.y, p.radius)
		end
	end
end
