require("class")
require("particles/particle")

Smoke = class(Particle)

function Smoke:_init()
	self.name = "Smoke"

	self.maxlife = 3
	self.life = self.maxlife

	self.size = 8

	self.pos = Vector(0, 0)
	self.prevpos = Vector(0, 0)
	self.vel = Vector(love.math.random(-20, 20), love.math.random(-150, -60))
	self.acc = Vector(0, -1)

	self.color = { 0.7, 0.7, 0.7, love.math.random() }
end

function Smoke:__tostring()
	return string.format("Smoke (%d, %d (prev: %d, %d), dx: %d, dy: %d)", self.pos.x, self.pos.y, self.prevx, self.prevy, self.vel.x, self.vel.y)
end

function Smoke:handleCollision(otherParticle)
	-- smoke does not collide
	if otherParticle.name == "Block" then
		self.pos = self.prevpos
	end
end

-- A particle knows how to update itself every iteration.
function Smoke:update(dt)
	-- first make sure we have the previous positions saved
	self.prevpos = self.pos

	self.pos = self.pos + self.vel * dt
	self.vel = self.vel + (self.acc)

	-- Diminish the life by the time delta.
    self.life = self.life - dt

    self:checkParticleBounds()
end

-- Will check the particle bounds, and if the window edges are hit, invert
-- the delta's, when applicable.
function Smoke:checkParticleBounds()
	-- Whether there is gravity or not, invert the dx of the particle.
	if self.pos.x < 0 then
		self.pos.x = 0
	end

	if self.pos.x + self.size >= love.graphics.getWidth() then
		self.pos.x = love.graphics.getWidth() - self.size
	end

	if self.pos.y <= 0 then
		self.pos.y = 0
		self.vel.y = 0
	end

	-- Check if the self goes beyond the screen's height.
	if self.pos.y + self.size >= love.graphics.getHeight() then
		-- First 'clamp' the value to the maximum height.
		self.pos.y = love.graphics.getHeight() - self.size
		self.vel.y = 0
	end
end

function Smoke:draw()
	local percentageLife = self.life / self.maxlife
	-- local size = 8 * percentageLife
	local size = 8-- * percentageLife
	self.color = { percentageLife, percentageLife, percentageLife, 1}
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.pos.x, self.pos.y, size, size)
end

-- =============================================================================
