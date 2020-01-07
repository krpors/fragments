require("class")

Particle = class()

function Particle:_init()
	self.collidable = true
	self.collisionCounter = 0
end

function Particle:collidesWithLeftOf(otherParticle)
	return
		self.prevx + self.size < otherParticle.x
		and self.x + self.size >= otherParticle.x
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
		and otherParticle.y < self.y + self.size
end

-- This function calculates the amount the particles overlap, if there is a
-- collision. This function only behaves correctly if there in fact is a
-- collision. The value returned is a value between (0, 1].
function Particle:overlapRatioWith(otherParticle)
	local selfArea = self.size * self.size
	local otherArea = otherParticle.size * otherParticle.size

	local x1 = self.x
	local x2 = self.x + self.size
	local x3 = otherParticle.x
	local x4 = otherParticle.x + otherParticle.size

	local y1 = self.y
	local y2 = self.y + self.size
	local y3 = otherParticle.y
	local y4 = otherParticle.y + otherParticle.size

	local width = math.max(x1, x3) - math.min(x2, x4)
	local height = math.max(y1, y3) - math.min(y2, y4)

	local overlapArea = width * height

	return (overlapArea * 2) / (selfArea + otherArea)
end
