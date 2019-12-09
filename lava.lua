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
	local s = [[Lava (%d, %d)
- Life   = %f
- Dx, Dy = (%2d, %2d)]]
	return string.format(s, self.x, self.y, self.life, self.dx, self.dy)
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
			self.dy = 0
			self.y = otherParticle.y - self.size - 0.1
		end

		-- Self is left of the other particle, check velocities.
		if self.x < otherParticle.x then
			-- we are moving to the right, meaning we must have hit a particle
			-- to the right of us.
			if self.dx > 0 then
				-- bounce back
				self.dx = -self.dx
			-- moving to the left, so a particle with a greater speed than us
			-- hit us, from the right.
			elseif self.dx < 0 then
				self.dx = self.dx - 10
			end
		-- self is to the right of the particle.
		elseif self.x > otherParticle.x then
			-- we are moving to the right, and we are hit from the left by a
			-- particle with a greater velocity.
			if self.dx > 0 then
				self.dx = self.dx + 10
			-- we are moving to the left, bounce
			elseif self.dx < 0 then
				self.dx = -self.dx
			end
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
	if self.y + self.size >= love.graphics.getHeight() then
		-- First 'clamp' the value to the maximum height.
		self.y = love.graphics.getHeight() - self.size
		self.dy = 0
	end
end

function Lava:draw()
	local percentageLife = self.life / self.maxlife
	-- self.color[4] = percentageLife

	local size = self.size-- + percentageLife
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.x, self.y, size, size)
	-- love.graphics.circle('fill', self.x, self.y, self.size * percentageLife)



	-- love.graphics.setDefaultFilter("nearest", "nearest", 1)
	-- love.graphics.setFont(globals.gameFont)
	-- love.graphics.setColor({1,1,1,1})
	-- love.graphics.print(string.format("%s", self), math.floor(self.x), math.floor(self.y - 40))
end

-- =============================================================================
