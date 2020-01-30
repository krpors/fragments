require("class")
require("particles/particle")
require("particles/smoke")

Plant = class(Particle)

function Plant:_init()
	self.name = "Plant"

	self.maxlife = 60
	self.life = self.maxlife

	self.size = 8

	self.pos = Vector(0, 0)
	self.prevpos = Vector(0, 0)
	self.vel = Vector(love.math.random(-10, 10), love.math.random(-10, 10))
	self.acc = Vector(0, 0)

	self.color = { 0.8, 1, 0.8, 1 }
end

function Plant:__tostring()
	return string.format("Plant")
end

function Plant:handleCollision(otherParticle)
	if otherParticle.name == "Block" then
		self.vel.y = 0
		self.pos = self.prevpos
		return
	end

	if self.name == otherParticle.name then
		self.vel = Vector(love.math.random(-100, 100), love.math.random(-100, 100))
	end

	if otherParticle.name == "Lava" then
		self.life = 0
		local smokeEmitter = Emitter(function() return Smoke() end )
		smokeEmitter:emitAt(self.pos.x, self.pos.y)
		smokeEmitter:setEmitting(true)
		smokeEmitter.life = 1
		smokeEmitter.expires = true
		self.world:addEmitter(smokeEmitter)
	end
end

-- A particle knows how to update itself every iteration.
function Plant:update(dt)
	-- first make sure we have the previous positions saved
	self.prevpos = self.pos

	-- Update the position by adding the velocity vector to the current position.
	self.pos = self.pos + self.vel * dt
	-- Then apply force (gravity) to the velocity vector.
	self.vel = self.vel + (self.acc)

	self.vel:lerp(0, 0.05)

	-- Diminish the life by the time delta.
    self.life = self.life - dt

    self:checkParticleBounds()
end

-- Will check the particle bounds, and if the window edges are hit, invert
-- the delta's, when applicable.
function Plant:checkParticleBounds()
	-- Whether there is gravity or not, invert the dx of the particle.
	if self.pos.x < 0 then
		self.pos.x = 0
		self.vel.x = -self.vel.x
	end

	if self.pos.x + self.size >= love.graphics.getWidth() then
		self.pos.x = love.graphics.getWidth() - self.size
		self.vel.x = -self.vel.x
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

function Plant:draw()
	local percentageLife = self.life / self.maxlife
	self.color[2] = percentageLife
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.size, self.size)
end

-- =============================================================================
