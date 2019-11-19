ParticleGenerator = {}
ParticleGenerator.__index = ParticleGenerator

-- This particle generator is a generator which can be used for H to play with.
function ParticleGenerator:new()
	local self = setmetatable({}, ParticleGenerator)

	-- Spawn point, or just the origin of the generator
	self.origin = { 0, 0 }

	-- The 'spread' or distributions in the x (left, right)
	-- and y (top, bottom) axes.
	self.delta = {
		x = { -80, 80 },
		y = { -80, 80 },
	}

	-- 'Gravity' modifier. 0 will disable gravity
	self.gravity = 0

	-- Set to true to loop the generator.
	self.continuous = false

	-- Life of each particle, in seconds.
	self.maxlife = 10

	-- Maximum radius in pixels, per particle.
	self.maxradius = 8

	self.particles = {}
	self.particleCount = 1000

	-- The colorfunction determines what color each particle gets during
	-- their lifetime. The default is
	self.colorfunction = function(lifepercentage)
		return {
			1,
			lifepercentage,
			lifepercentage,
			1
		}
	end

	return self
end

--[[
-- Initializes the particle generator with all the parameters involved. This will
-- re-create the particles table (with zero particles), then initializes all particles
-- with the given properties.
--]]
function ParticleGenerator:init(origin)
	self.origin = origin
	self.particles = {}

	for i = 1, self.particleCount do
		local p = {}
		self:resetParticle(p)

		table.insert(self.particles, p)
	end
end

-- Resets a particle's parameters, by using the properties of the
-- parent generator.
function ParticleGenerator:resetParticle(p)
	local maxlife = love.math.random() * self.maxlife

	p.x         = self.origin[1]
	p.y         = self.origin[2]
	p.color     = self.colorfunction(1)
	p.radius    = self.maxradius
	p.maxradius = self.maxradius
	p.dx        = love.math.random(self.delta.x[1], self.delta.x[2])
	p.dy        = love.math.random(self.delta.y[1], self.delta.y[2])
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
			p.dy = p.dy - self.gravity

			if p.x <= 0 or p.x >= love.graphics.getWidth() then
				p.dx = -p.dx
			end

			p.color = self.colorfunction(lifepercentage)

			p.life = p.life - dt
			-- Change the radius. The radius must decline to zero in proportion
			-- to the lifetime of the particle. Meaning, if the lifetime of the
			-- particle is 4.8 seconds, after 4.8 seconds we must have reached
			-- a radius of 0. We do that by just setting by calculating the
			-- percentage of the lifetime, multiplied by the original max radius.
			p.radius = p.maxradius * (lifepercentage)
		elseif p.life < 0 and self.continuous then
			-- If we need to emit continuously, reset the particle.
			self:resetParticle(p)
		end
	end
end

function ParticleGenerator:draw()
	-- love.graphics.setPointSize(1)

	for k, p in ipairs(self.particles) do
		if p and p.life > 0 then
			love.graphics.setColor(p.color)
			love.graphics.circle('fill', p.x, p.y, p.radius)
			-- love.graphics.points(p.x, p.y)
		end
	end
end
