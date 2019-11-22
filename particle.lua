-- Particle is a single particle with properties. The behaviour is depending
-- on the particle's element. A particle knows how to update itself.
Particle = {}
Particle.__index = Particle

function Particle:new(element)
	local self = setmetatable({}, Particle)

	-- TODO: initialize from element
	self.element = element
	self.life = element.life

	self.size = 3
	self.x = 0
	self.y = 0
	self.prevx = 0
	self.prevy = 0
	self.dx = love.math.random(self.element.delta.x[1], self.element.delta.x[2])
	self.dy = love.math.random(self.element.delta.y[1], self.element.delta.y[2])
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
	self.x = self.x + love.math.random(-0.5, 0.5) * self.size
	self.y = self.y + love.math.random(-0.5, 0.) * self.size
end

function Particle:handleCollision(otherParticle)
	if self.element == otherParticle.element then
		self:moveInRandomDirection()
	end
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

-- A particle knows how to update itself every iteration.
function Particle:update(dt)
	-- first make sure we have the previous positions saved
	self.prevx = self.x
	self.prevy = self.y

	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
	self.dy = self.dy + self.element.gravity

	-- Diminish the life by the time delta.
    self.life = self.life - dt

    self:checkParticleBounds()
end

-- Will check the particle bounds, and if the window edges are hit, invert
-- the delta's, when applicable.
function Particle:checkParticleBounds()
	-- Whether there is gravity or not, invert the dx of the particle.
	if self.x <= 0 or self.x >= love.graphics.getWidth() then
		self.dx = -math.abs(self.dx)
	end

	if self.y <= 0 then
		if self.element.gravity < 0 then
			self.y = 0
		else
			self.dy = math.abs(self.dy)
		end
	end

	-- Check if the self goes beyond the screen's height.
	if self.y >= love.graphics.getHeight() then
		-- First 'clamp' the value to the maximum height.
		self.y = love.graphics.getHeight() - self.size

		-- If there is zero gravity, it should act like a gas. In that case
		-- invert the y axis at all times.
		if self.element.gravity == 0 then
			self.dy = -math.abs(self.dy)
		else
			self.y = love.graphics.getHeight() - self.size
		end
	end
end

function Particle:draw()
    love.graphics.setColor(self.element.color.cool)
    love.graphics.circle('fill', self.x, self.y, self.size)
end
