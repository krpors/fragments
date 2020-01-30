require("class")
require("particles/particle")

Oxygen = class(Particle)

function Oxygen:_init()
	self.name = "Oxygen"

	self.maxlife = 10
	self.life = self.maxlife

	self.size = 3

	self.pos = Vector(0, 0)
	self.prevpos = self.pos
	self.vel = Vector(love.math.random(-80, 80), love.math.random(-80, 80))
	self.acc = Vector(0, 0)

	self.color = { 1, 1, 1, 1 }
end

function Oxygen:__tostring()
	return string.format("Oxygen (%d, %d), life: %f", self.x, self.y, self.life)
end

function Oxygen:moveInRandomDirection()
	print("todo")
end

function Oxygen:handleCollision(otherParticle)
	if self.name == otherParticle.name then
		self:moveInRandomDirection()
	end
end

-- A particle knows how to update itself every iteration.
function Oxygen:update(dt)
	-- first make sure we have the previous positions saved
	self.prevpos = self.pos

	-- Update the position by adding the velocity vector to the current position.
	self.pos = self.pos + self.vel * dt
	-- Then apply force (gravity) to the velocity vector.
	self.vel = self.vel + (self.acc)
	self.vel:lerp(0, 0.01)

	-- Diminish the life by the time delta.
    self.life = self.life - dt

    self:checkParticleBounds()
end

-- Will check the particle bounds, and if the window edges are hit, invert
-- the delta's, when applicable.
function Oxygen:checkParticleBounds()
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
	if self.pos.y >= love.graphics.getHeight() then
		-- First 'clamp' the value to the maximum height.
		self.pos.y = love.graphics.getHeight() - self.size

		-- If there is zero gravity, it should act like a gas. In that case
		-- invert the y axis at all times.
		self.vel.y = -math.abs(self.vel.y)
		self.pos.y = love.graphics.getHeight() - self.size
	end
end

function Oxygen:draw()
	local percentageLife = self.life / self.maxlife
	self.color[4] = percentageLife

	love.graphics.setColor(self.color)
	love.graphics.circle('fill', self.pos.x, self.pos.y, self.size * percentageLife)
end

-- =============================================================================
