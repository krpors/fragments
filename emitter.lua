Particle = {}
Particle.__index = Particle

-- Particle is a single particle with properties.
function Particle:new()
	local self = setmetatable({}, Particle)

	self.life = 1
	self.size = 2
	self.pos {
		x = 0,
		y = 0,
	}

	return self
end

Emitter = {}
Emitter.__index = Emitter

function Emitter:new()
	local self = setmetatable({}, Emitter)
	return self
end

function Emitter:update()
end

function Emitter:draw()
end
