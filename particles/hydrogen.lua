require("class")
require("particles/particle")
require("vector")

Hydrogen = class(Particle)

function Hydrogen:_init()
	self.name = "Hydrogen"

	self.maxlife = 5
	self.life = self.maxlife

	self.size = 5

	self.pos = Vector(300, 300)
	self.vel = Vector(love.math.random(-90, 90), love.math.random(-90, 90))

	self.x = 0
	self.y = 0

	self.prevx = 0
	self.prevy = 0

	self.dx = love.math.random(-90, 90)
	self.dy = love.math.random(-90, 90)

	self.color = { 0, 0.5, 1, 1 }
end

function Hydrogen:__tostring()
	return string.format("Hydrogen (%d, %d), life: %f", self.x, self.y, self.life)
end

function Hydrogen:handleCollision(otherParticle)
	if otherParticle.is_a[Oxygen] then
		self.dx = 0
		self.dy = 0
		self.life = 0
	end
end

function Hydrogen:update(dt)
	self.pos = self.pos + (self.vel * dt)

	-- Diminish the life by the time delta.
    self.life = self.life - dt

    self:checkParticleBounds()
end

-- Will check the particle bounds, and if the window edges are hit, invert
-- the delta's, when applicable.
function Hydrogen:checkParticleBounds()
	-- Whether there is gravity or not, invert the dx of the particle.
	if self.x < 0 then
		self.x = 0
		self.dx = math.abs(self.dx)
	end

	if self.x >= love.graphics.getWidth() then
		self.x = love.graphics.getWidth() - self.size
		self.dx = -math.abs(self.dx)
	end

	if self.y <= 0 then
		self.y = self.size
		self.dy = math.abs(self.dy)
	end

	-- Check if the self goes beyond the screen's height.
	if self.y + self.size >= love.graphics.getHeight() then
		-- First 'clamp' the value to the maximum height.
		self.y = love.graphics.getHeight() - self.size

		-- If there is zero gravity, it should act like a gas. In that case
		-- invert the y axis at all times.
		self.dy = -math.abs(self.dy)
		self.y = love.graphics.getHeight() - self.size
	end
end

function Hydrogen:draw()
	local percentageLife = self.life / self.maxlife
	self.color[4] = percentageLife

	love.graphics.setColor(self.color)
	local size = self.size * percentageLife
	-- love.graphics.circle('fill', self.x, self.y, size)
	love.graphics.circle('fill', self.pos.x, self.pos.y, size)
	-- love.graphics.rectangle('fill', self.x, self.y, size, size)
end

-- =============================================================================
