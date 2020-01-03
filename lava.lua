require("class")
require("particle")

Lava = class(Particle)

function Lava:_init()
	self.name = "Lava"

	self.maxlife = 20
	self.life = self.maxlife

	self.size = 8

	self.x = 0
	self.y = 0

	self.prevx = 0
	self.prevy = 0

	self.dx = love.math.random(-200, 200)
	self.dy = love.math.random(-50, 0)

	self.color = {
		1,
		love.math.random(),
		0,
		1,
	 }
end

function Lava:__tostring()
	return string.format("Lava (%d, %d (prev: %d, %d), dx: %d, dy: %d)", self.x, self.y, self.prevx, self.prevy, self.dx, self.dy)
-- 	local s = [[Lava (%d, %d)
-- - Life   = %f
-- - Dx, Dy = (%2d, %2d)]]
-- 	return string.format(s, self.x, self.y, self.life, self.dx, self.dy)
end

function Lava:handleCollision(otherParticle)
	if otherParticle.name == "Block" then
		self.dy = 0
		-- self.x = self.prevx
		-- self.y = self.prevy

		if self:collidesWithTopOf(otherParticle) then
			self.dy = 0
			self.y = self.prevy
		end

		if self:collidesWithLeftOf(otherParticle) then
			self.dx = -self.dx
			self.dx = lerp(self.dx, 0, 0.5)
			self.x = self.prevx
		end

		if self:collidesWithRightOf(otherParticle) then
			self.dx = -self.dx
			self.x = self.prevx
		end
	end

	if self.name == otherParticle.name then
		-- is the current particle above the other particle? Then align ourselves
		-- with the other particle's y axis
		if self:collidesWithTopOf(otherParticle) then
			self.dy = 0
			-- self.y = otherParticle.y - self.size - 1
			self.y = self.prevy
		end

		if self:collidesWithLeftOf(otherParticle) then
			self.dx = -self.dx
		end

		if self:collidesWithRightOf(otherParticle) then
			self.dx = -self.dx
		end

	end
end

-- A particle knows how to update itself every iteration.
function Lava:update(dt)
	-- first make sure we have the previous positions saved
	self.prevx = self.x
	self.prevy = self.y

	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	self.dx = lerp(self.dx, 0, 0.01)

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
		self.dx = -self.dx
	end

	if self.x + self.size >= love.graphics.getWidth() then
		self.x = love.graphics.getWidth() - self.size
		self.dx = -self.dx
	end

	if self.y <= 0 then
		self.y = self.size
		self.dy = math.abs(self.dy)
	end

	-- Check if the self goes beyond the screen's height.
	if self.y + self.size >= love.graphics.getHeight() then
		-- First 'clamp' the value to the maximum height.
		self.y = love.graphics.getHeight() - self.size
		self.dy = 0
	end
end

function Lava:draw()
	local lifeperc = self.life / self.maxlife
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end

-- =============================================================================
