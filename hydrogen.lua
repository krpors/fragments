require("class")
Hydrogen = class()

function Hydrogen:_init()
	self.name = "Hydrogen"

	self.maxlife = 5
	self.life = self.maxlife

	self.size = 5

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

function Hydrogen:moveToPreviousPosition()
	self.x = self.prevx
	self.y = self.prevy
end

function Hydrogen:moveInRandomDirection()
	self.x = self.x + love.math.random(-0.5, 0.5) * self.size
	self.y = self.y + love.math.random(-0.5, 0.5) * self.size
end

function Hydrogen:handleCollision(otherParticle)
	if self.name == otherParticle.name then
		self:moveInRandomDirection()
	end
end

-- Returns true when this particle collides with another particle
function Hydrogen:collidesWith(otherParticle)
	-- just do a simple bounding box collision detection
	return
		    self.x < otherParticle.x + otherParticle.size
		and otherParticle.x < self.x + self.size
		and self.y < otherParticle.y + otherParticle.size
		and otherParticle.y < self.y + self.size
end

-- A particle knows how to update itself every iteration.
function Hydrogen:update(dt)
	-- first make sure we have the previous positions saved
	self.prevx = self.x
	self.prevy = self.y

	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

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
	if self.y >= love.graphics.getHeight() then
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
	love.graphics.circle('fill', self.x, self.y, size)
	-- love.graphics.rectangle('fill', self.x, self.y, size, size)
end

-- =============================================================================
