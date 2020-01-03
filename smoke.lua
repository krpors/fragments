require("class")
require("particle")

Smoke = class(Particle)

function Smoke:_init()
	self.name = "Smoke"

	self.maxlife = 5
	self.life = self.maxlife

	self.size = 8

	self.x = 0
	self.y = 0

	self.prevx = 0
	self.prevy = 0

	self.dx = love.math.random(-20, 20)
	self.dy = love.math.random(-150, -60)

	self.color = { 0.7, 0.7, 0.7, love.math.random() }
end

function Smoke:__tostring()
	return string.format("Smoke (%d, %d (prev: %d, %d), dx: %d, dy: %d)", self.x, self.y, self.prevx, self.prevy, self.dx, self.dy)
end

function Smoke:handleCollision(otherParticle)
	-- smoke does not collide
end

-- A particle knows how to update itself every iteration.
function Smoke:update(dt)
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
function Smoke:checkParticleBounds()
	-- Whether there is gravity or not, invert the dx of the particle.
	if self.x < 0 then
		self.x = 0
		self.dx = -self.dx
	end

	if self.x + self.size >= love.graphics.getWidth() then
		self.x = love.graphics.getWidth() - self.size
		self.dx = -self.dx
	end

	if self.y <= 0 then
		self.y = 0
		self.dy = 0
	end

	-- Check if the self goes beyond the screen's height.
	if self.y + self.size >= love.graphics.getHeight() then
		-- First 'clamp' the value to the maximum height.
		self.y = love.graphics.getHeight() - self.size
		self.dy = 0
	end
end

function Smoke:draw()
	local percentageLife = self.life / self.maxlife
	self.color[2] = percentageLife
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end

-- =============================================================================
