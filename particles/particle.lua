require("class")
require("vector")

Particle = class()

function Particle:collidesWithLeftOf(otherParticle)
	return
		self.prevpos.x + self.size < otherParticle.pos.x
		and self.pos.x + self.size > otherParticle.pos.x
end

function Particle:collidesWithRightOf(otherParticle)
	return
		self.prevpos.x > otherParticle.pos.x + otherParticle.size
		and self.pos.x < otherParticle.pos.x + otherParticle.size
end

function Particle:collidesWithTopOf(otherParticle)
	return
		self.prevpos.y + self.size < otherParticle.pos.y
		and self.pos.y + self.size > otherParticle.pos.y
end

function Particle:collidesWithBottomOf(otherParticle)
	return
		self.prevpos.y > otherParticle.pos.y + otherParticle.size
		and self.pos.y < otherParticle.pos.y + otherParticle.size
end

-- Returns true when this particle collides with another particle
function Particle:collidesWith(otherParticle)

	-- just do a simple bounding box collision detection
	return
			self.pos.x <= otherParticle.pos.x + otherParticle.size
		and otherParticle.pos.x <= self.pos.x + self.size
		and self.pos.y <= otherParticle.pos.y + otherParticle.size
		and otherParticle.pos.y <= self.pos.y + self.size
end

-- This function calculates the amount the particles overlap, if there is a
-- collision. This function only behaves correctly if there in fact is a
-- collision. The value returned is a value between (0, 1].
function Particle:overlapRatioWith(otherParticle)
	local selfArea = self.size * self.size
	local otherArea = otherParticle.size * otherParticle.size

	local x1 = self.pos.x
	local x2 = self.pos.x + self.size
	local x3 = otherParticle.pos.x
	local x4 = otherParticle.pos.x + otherParticle.size

	local y1 = self.pos.y
	local y2 = self.pos.y + self.size
	local y3 = otherParticle.pos.y
	local y4 = otherParticle.pos.y + otherParticle.size

	local width = math.max(x1, x3) - math.min(x2, x4)
	local height = math.max(y1, y3) - math.min(y2, y4)

	local overlapArea = width * height

	return (overlapArea * 2) / (selfArea + otherArea)
end
