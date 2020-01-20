require("class")
require("spatialgrid")
require("emitter")
require("particles/hydrogen")
require("particles/oxygen")
require("particles/lava")
require("particles/block")
require("particles/plant")
require("particles/smoke")

-- World contains the emitters and such.
World = class()

function World:_init()
	self.placedEmitters = {}

	self.placedBlocks = {}

	-- The grid which is used for broad-phased collision detection.
	self.spatialGrid = SpatialGrid()
end

function World:addBlock(x, y)
	local b = Block()
	b.x = math.floor(x / b.size) * b.size
	b.y = math.floor(y / b.size) * b.size

	print(string.format("Placing block at %3d, $3d", b.x, b.y))

	table.insert(self.placedBlocks, b)
end

-- Generator function is a function which returns a new Particle.
function World:addEmitter(emitter)
	emitter.world = self
	table.insert(self.placedEmitters, emitter)
end

function World:setGridSize(delta)
	if delta > 0 then
		self.spatialGrid.gridSize = self.spatialGrid.gridSize + 1
	elseif delta < 0 then
		self.spatialGrid.gridSize = math.max(1, self.spatialGrid.gridSize - 1)
	end

	self.spatialGrid:reinitialize()
end

function World:update(dt)
	-- Check emitters if some are eligible for removal (life is less than zero,
	-- and all particles in the emitter are dead)
	table.removeif(self.placedEmitters, function(p) return p:isExpired() end)

	self.spatialGrid:reinitialize()

	for _, emitter in ipairs(self.placedEmitters) do
		emitter:update(dt)

		-- Add all particles to the spatial grid, for the broadphase collision
		-- detection before narrowing it down.
		for _, v in ipairs(emitter.particles) do
			self.spatialGrid:addParticle(v)
		end
	end

	for _, block in ipairs(self.placedBlocks) do
		self.spatialGrid:addParticle(block)
	end

	self.spatialGrid:checkCollisions()
end

function World:draw()
	self.spatialGrid:draw()

	for i, emitter in ipairs(self.placedEmitters) do
		emitter:draw()
	end

	for _, v in ipairs(self.placedBlocks) do
		v:draw()
	end
end
