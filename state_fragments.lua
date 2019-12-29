require("class")
require("spatialgrid")
require("emitter")
require("hydrogen")
require("oxygen")
require("lava")
require("block")

-- A ParticleFactory is merely a simple container with a name and the generator
-- function for creating new particles. This generator function can then be
-- passed to the emitter when dropping an emitter on the 'playing field'.
ParticleFactory = class()

function ParticleFactory:_init(name, generatorFunction)
	self.name = name
	self.generatorFunction = generatorFunction
end

-- This is the state class for the main gameplay.
StateFragments = class()

function StateFragments:_init()
	-- The particle factories which can be selected by the user.
	self.particleFactories = {}
	table.insert(self.particleFactories, ParticleFactory("hydrogen", function() return Hydrogen() end ))
	table.insert(self.particleFactories, ParticleFactory("lava", function() return Lava() end ))
	table.insert(self.particleFactories, ParticleFactory("oxygen", function() return Oxygen() end ))

	-- The circular iterator and the current selected particle factory.
	self.nextParticleFactory = circular_iter(self.particleFactories)
	self.currentParticleFactory = self.nextParticleFactory()

	self.paused = false

	-- The emitters placed on the screen.
	self.placedEmitters = {}

	self.placedBlocks = {}

	-- The grid which is used for broad-phased collision detection.
	self.spatialGrid = SpatialGrid()

	self.statusPlaceBlock = false

	self.mousePosition = {
		x = 0,
		y = 0,
	}
end


function StateFragments:mousePressed(x, y, button, istouch, presses)
	if button == 1 then
		if self.statusPlaceBlock then
			local b = Block()
			b.x = x
			b.y = y
			table.insert(self.placedBlocks, b)
			-- 1. add 'block' to a different table?
			-- 2. update/draw the blocks.
			-- 3. check for collisions with particles.
		else
			-- Create a new Emitter, using the generator function of the current
			-- factory so it starts spewing stuff at the given x,y position.
			local e = Emitter(self.currentParticleFactory.generatorFunction)
			e:emitAt(x, y)
			e:setEmitting(true)
			table.insert(self.placedEmitters, e)
		end
	end
end

function StateFragments:mouseReleased(x, y, button, istouch, presses)
end

function StateFragments:mouseMoved(x, y, dx, dy, istouch)
	self.mousePosition = { x = x, y = y }
	self.spatialGrid.mousePosition = { x, y }
end

function StateFragments:mouseWheelMoved(x, y)
	if y > 0 then
		self.spatialGrid.gridSize = self.spatialGrid.gridSize + 1
	elseif y < 0 then
		self.spatialGrid.gridSize = math.max(1, self.spatialGrid.gridSize - 1)
	end

	self.spatialGrid:reinitialize()
end

function StateFragments:keyPressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == ']'  then
		self.currentParticleFactory = self.nextParticleFactory()
	elseif key == 'd' then
		print(self.spatialGrid.particleCount)
		self.spatialGrid:print()
	elseif key == 'b' then
		self.statusPlaceBlock = not self.statusPlaceBlock
	elseif key == 'p' then
		self.paused = not self.paused
	elseif key == 'k' then
		print(collectgarbage("count"))
		for i, v in ipairs(self.placedEmitters) do
			print("Nilling", v)
			v = nil
		end
		self.placedEmitters = nil
		self.placedEmitters = {}
		print(collectgarbage("count"))
	end
end

function StateFragments:update(dt)
	-- always reinitialize the grid for now
	if self.paused then return end

	self.spatialGrid:reinitialize()

	for i, emitter in ipairs(self.placedEmitters) do
		emitter:update(dt)

		-- Add all particles to the spatial grid, for the broadphase collision
		-- detection before narrowing it down.
		for i, v in ipairs(emitter.particles) do
			self.spatialGrid:addParticle(v)
		end
	end

	for _, block in ipairs(self.placedBlocks) do
		self.spatialGrid:addParticle(block)
	end

	self.spatialGrid:checkCollisions()
end

function StateFragments:draw()
	self.spatialGrid:draw()

	for i, emitter in ipairs(self.placedEmitters) do
		emitter:draw()
	end

	for _, v in ipairs(self.placedBlocks) do
		v:draw()
	end

	love.graphics.setFont(globals.gameFont)
	love.graphics.setColor(1, 1, 1, 1)

	local debugstr = string.format("FPS: %d\n", love.timer.getFPS())
	debugstr = debugstr .. string.format("KB used: %d\n", collectgarbage("count"))
	debugstr = debugstr .. string.format("Number of particles: %d\n", self.spatialGrid.particleCount)

	local cell = self.spatialGrid:getCellAt(self.mousePosition.x, self.mousePosition.y)
	local count = self.spatialGrid:getParticleCountAt(self.mousePosition.x, self.mousePosition.y)
	debugstr = debugstr .. string.format("Number of particles at (%2d, %2d) = %3d\n", cell.row, cell.col, count)

	debugstr = debugstr .. string.format("Current generator: %s\n", self.currentParticleFactory.name)

	if self.paused then
		debugstr = debugstr .. "Paused!\n"
	end

	love.graphics.print(debugstr, 0, 0)
end
