require("class")
require("particles/particle")
require("vector")

Hydrogen = class(Particle)

function Hydrogen:_init()
	self.name = "Hydrogen"

	self.maxlife = 50
	self.life = self.maxlife

	self.size = 5

	self.pos = Vector(300, 300)
	self.vel = Vector(love.math.random(-50, 50), love.math.random(-50, 50))
	self.acc = Vector(0, 0)

	self.color = { 0, 0.5, 1, 1 }
end

function Hydrogen:__tostring()
	return string.format("Hydrogen (%d, %d), life: %f", self.pos.x, self.pos.y, self.life)
end

function Hydrogen:handleCollision(otherParticle)
end

function Hydrogen:update(dt)
	self.pos = self.pos + (self.vel * dt)
	self.vel = self.vel + self.acc

	-- Diminish the life by the time delta.
	self.life = self.life - dt

    self:checkParticleBounds()
end

-- Will check the particle bounds, and if the window edges are hit, invert
-- the delta's, when applicable.
function Hydrogen:checkParticleBounds()
	-- Whether there is gravity or not, invert the dx of the particle.
	if self.pos.x < 0 then
		self.pos.x = 0
		self.vel.x = math.abs(self.vel.x)
	end

	if self.pos.x >= love.graphics.getWidth() then
		self.pos.x = love.graphics.getWidth() - self.size
		self.vel.x = -math.abs(self.vel.x)
	end

	if self.pos.y <= 0 then
		self.pos.y = self.size
		self.vel.y = math.abs(self.vel.y)
	end

	-- Check if the self goes beyond the screen's height.
	if self.pos.y + self.size >= love.graphics.getHeight() then
		-- First 'clamp' the value to the maximum height.
		self.pos.y = love.graphics.getHeight() - self.size

		-- If there is zero gravity, it should act like a gas. In that case
		-- invert the y axis at all times.
		self.vel.y = -math.abs(self.vel.y)
		self.pos.y = love.graphics.getHeight() - self.size
	end
end

function Hydrogen:draw()
	local percentageLife = self.life / self.maxlife
	self.color[4] = percentageLife

	love.graphics.setColor(self.color)
	local size = self.size * percentageLife
	-- love.graphics.circle('fill', self.pos.x, self.pos.y, size)
	love.graphics.circle('fill', self.pos.x, self.pos.y, size)
	-- love.graphics.rectangle('fill', self.pos.x, self.pos.y, size, size)
end

-- =============================================================================
