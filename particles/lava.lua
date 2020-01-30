require("class")
require("particles/particle")

Lava = class(Particle)

function Lava:_init()
	self.name = "Lava"

	self.maxlife = 20
	self.life = self.maxlife

	self.size = 8

	self.pos = Vector(0, 0)
	self.prevpos = Vector(0, 0)
	self.vel = Vector(love.math.random(-10, 10), 0)
	self.acc = Vector(0, 9)

	self.color = {
		1,
		love.math.random(),
		0,
		1,
	 }
end

function Lava:__tostring()
	return string.format("Lava")
end

function Lava:handleCollision(otherParticle)
	if otherParticle.name == "Block" then
		if self:collidesWithTopOf(otherParticle) then
			self.vel.y = 0
			self.pos.y = otherParticle.pos.y - self.size - 1
		end

		if self:collidesWithLeftOf(otherParticle) then
			self.pos.x = otherParticle.pos.x - self.size - 1
			self.vel.x = self.vel.x * -1
			-- self.dx = -self.dx
			-- self.dx = lerp(self.dx, 0, 0.5)
		end

		if self:collidesWithRightOf(otherParticle) then
			self.pos.x = otherParticle.pos.x + otherParticle.size + 1
			self.vel.x = self.vel.x * -1
		end

		if self:collidesWithBottomOf(otherParticle) then
			self.vel.y = 0
			self.pos.y = otherParticle.pos.y + otherParticle.size + 1
		end

	end

	if self.name == otherParticle.name then
		-- is the current particle above the other particle? Then align ourselves
		-- with the other particle's y axis
		if self:collidesWithTopOf(otherParticle) then
			-- otherParticle.dy = otherParticle.dy + self.dy
			self.vel.y = 0
			self.pos.y = otherParticle.pos.y - self.size - 1
			return
			-- self.pos = self.prevpos
		end

		if self:collidesWithLeftOf(otherParticle) then
			-- self.vel.x = self.vel.x + otherParticle.vel.x
			self.vel.x = self.vel.x * -1
			self.vel.x = lerp(self.vel.x, 0, 0.1)
		end

		if self:collidesWithRightOf(otherParticle) then
			-- self.vel.x = self.vel.x + otherParticle.vel.x
			self.vel.x = self.vel.x * -1
			self.vel.x = lerp(self.vel.x, 0, 0.1)
		end

		if self:collidesWithBottomOf(otherParticle) then
			-- self.vel.x = self.vel.x + otherParticle.vel.x
			self.vel.y = 0
			-- self.vel.x = lerp(self.vel.x, 0, 0.1)
		end

		if self:overlapRatioWith(otherParticle) >= 0.5 then
			self.vel.x = love.math.random(-50, 50)
			self.vel.y = love.math.random(-40, 9)
		end
	end
end

-- A particle knows how to update itself every iteration.
function Lava:update(dt)
	-- first make sure we have the previous positions saved
	self.prevpos = self.pos

	-- Update  the position by adding the velocity vector to the current position.
	self.pos = self.pos + self.vel * dt
	-- Then apply force (gravity) to the velocity vector.
	self.vel = self.vel + (self.acc)

	-- Diminish the life by the time delta.
	self.life = self.life - dt

	self.color[2] = 1 - (self.life / self.maxlife)

	self:checkParticleBounds()
end

-- Will check the particle bounds, and if the window edges are hit, invert
-- the delta's, when applicable.
function Lava:checkParticleBounds()
	-- Whether there is gravity or not, invert the dx of the particle.
	if self.pos.x < 0 then
		self.pos.x = 0
		self.vel.x = self.vel.x * -1
	end

	if self.pos.x + self.size >= love.graphics.getWidth() then
		self.pos.x = love.graphics.getWidth() - self.size
		self.vel.x = self.vel.x * -1
	end

	if self.pos.y <= 0 then
		self.pos.y = self.size
		self.vel.y = math.abs(self.vel.y)
	end

	-- Check if the self goes beyond the screen's height.
	if self.pos.y + self.size >= love.graphics.getHeight() then
		-- First 'clamp' the value to the maximum height.
		self.pos.y = love.graphics.getHeight() - self.size
		self.vel.y = 0
	end
end

function Lava:draw()
	local lifeperc = self.life / self.maxlife
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.size, self.size)
end

-- =============================================================================
