require("class")

Particle = class()

function Particle:_init()
end

function Particle:collidesWithLeftOf(otherParticle)
	return
		self.prevx + self.size < otherParticle.x
		and self.x >= otherParticle.x
end

function Particle:collidesWithRightOf(otherParticle)
	return
		self.prevx > otherParticle.x + otherParticle.size
		and self.x <= otherParticle.x + otherParticle.size
end

function Particle:collidesWithTopOf(otherParticle)
	return
		self.prevy + self.size < otherParticle.y
		and self.y + self.size >= otherParticle.y
end

function Particle:collidesWithBottomOf(otherParticle)
	return
		self.prevy > otherParticle.y + otherParticle.size
		and self.y <= otherParticle.y + otherParticle.size
end

-- Returns true when this particle collides with another particle
function Particle:collidesWith(otherParticle)
	-- just do a simple bounding box collision detection
	return
			self.x < otherParticle.x + otherParticle.size
		and otherParticle.x < self.x + self.size
		and self.y < otherParticle.y + otherParticle.size
		and otherParticle.y < self.y + self.size - 1
end
