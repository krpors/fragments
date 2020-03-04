require("class")
require("particles/particle")
require("particles/smoke")

Plant = class(Particle)

function Plant:_init()
	self.name = "Plant"

	self.maxlife = 60
	self.life = self.maxlife

	self.size = 8

	self.x = 0
	self.y = 0

	self.prevx = 0
	self.prevy = 0

	self.dx = love.math.random(-10, 10)
	self.dy = love.math.random(-10, 10)

	self.color = { 0.8, 1, 0.8, 1 }
end

function Plant:__tostring()
	return string.format("Plant (%d, %d (prev: %d, %d), dx: %d, dy: %d)", self.x, self.y, self.prevx, self.prevy, self.dx, self.dy)
end

function Plant:handleCollision(otherParticle)
	if otherParticle.name == "Block" then
		self.dy = 0
		self.x = self.prevx
		self.y = self.prevy
		return
	end

	if self.name == otherParticle.name then
		-- self.vel = Vector(love.math.random(-100, 100), love.math.random(-100, 100))
		-- self.vel.x = self.vel.x + otherParticle.vel.x
		-- self.vel.y = self.vel.y + otherParticle.vel.y
	end

	if otherParticle.name == "Lava" then
		self.life = 0
		local smokeEmitter = Emitter(function() return Smoke() end )
		smokeEmitter:emitAt(self.x, self.y)
		smokeEmitter:setEmitting(true)
		smokeEmitter.life = 1
		smokeEmitter.expires = true
		self.world:addEmitter(smokeEmitter)
	end
end

-- A particle knows how to update itself every iteration.
function Plant:update(dt)
	-- first make sure we have the previous positions saved
	self.prevx = self.x
	self.prevy = self.y

	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	self.dx = lerp(self.dx, 0, 0.2)
	self.dy = lerp(self.dy, 0, 0.2)

	-- Diminish the life by the time delta.
    self.life = self.life - dt

    self:checkParticleBounds()
end

-- Will check the particle bounds, and if the window edges are hit, invert
-- the delta's, when applicable.
function Plant:checkParticleBounds()
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

function Plant:draw()
	local percentageLife = self.life / self.maxlife
	self.color[2] = percentageLife
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end

-- =============================================================================
