require("class")

Lava = class()

function Lava:_init()
	self.name = "Lava"

	self.maxlife = 5
	self.life = self.maxlife

	self.size = 8

	self.x = 0
	self.y = 0

	self.prevx = 0
	self.prevy = 0

	self.dx = love.math.random(-100, 100)
	self.dy = love.math.random(0, 80)

	self.color = { 1, 0, 0, 1 }
end

function Lava:__tostring()
	return string.format("Lava (%d, %d), life: %f", self.x, self.y, self.life)
end

function Lava:moveInRandomDirection()
	self.x = self.x + love.math.random(-0.5, 0.5) * self.size
	self.y = self.y + love.math.random(-0.5, 0.5) * self.size
end

function Lava:handleCollision(otherParticle)
	if self.name == otherParticle.name then
		-- is the current particle above the other particle? Then align ourselves
		-- with the other particle's y axis
		if self.y < otherParticle.y then
			self.dx = 0
			self.dy = 0
			print("lol")
			self.y = otherParticle.y - self.size - 0.1
		end
	end
end

-- Returns true when this particle collides with another particle
function Lava:collidesWith(otherParticle)
	-- just do a simple bounding box collision detection
	return
		    self.x < otherParticle.x + otherParticle.size
		and otherParticle.x < self.x + self.size
		and self.y < otherParticle.y + otherParticle.size
		and otherParticle.y < self.y + self.size - 1
end

-- A particle knows how to update itself every iteration.
function Lava:update(dt)
	-- first make sure we have the previous positions saved
	self.prevx = self.x
	self.prevy = self.y

	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
	self.dy = self.dy + 9

	-- Diminish the life by the time delta.
    self.life = self.life - dt

    self:checkParticleBounds()
end

-- Will check the particle bounds, and if the window edges are hit, invert
-- the delta's, when applicable.
function Lava:checkParticleBounds()
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
	end
end

function Lava:draw()
	local percentageLife = self.life / self.maxlife
	-- self.color[4] = percentageLife

	local size = self.size-- + percentageLife
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.x, self.y, size, size)
	-- love.graphics.circle('fill', self.x, self.y, self.size * percentageLife)
end

-- =============================================================================
