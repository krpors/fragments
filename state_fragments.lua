require("class")
require("world")
require("spatialgrid")
require("emitter")
require("particles/hydrogen")
require("particles/oxygen")
require("particles/lava")
require("particles/block")
require("particles/plant")
require("particles/smoke")

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
	table.insert(self.particleFactories, ParticleFactory("plant", function() return Plant() end ))
	table.insert(self.particleFactories, ParticleFactory("smoke", function() return Smoke() end ))

	-- The circular iterator and the current selected particle factory.
	self.nextParticleFactory = circular_iter(self.particleFactories)
	self.currentParticleFactory = self.nextParticleFactory()

	self.paused = false

	self.statusPlaceBlock = false

	self.mousePosition = {
		x = 0,
		y = 0,
	}

	local p1 = Particle()
	p1.x = 10
	p1.y = 10
	p1.size = 5

	local p2 = Particle()
	p2.x = 13
	p2.y = 10
	p2.size = 5

	if p1:collidesWith(p2) then
		local perc1 = p2:overlapRatioWith(p1)
		local perc2 = p1:overlapRatioWith(p2)
		print(perc1, perc2)
	end

	self.world = World()


	self.world:addBlock(11 * 16, 5 * 16)
	self.world:addBlock(12 * 16, 5 * 16)
	self.world:addBlock(13 * 16, 5 * 16)
	self.world:addBlock(14 * 16, 5 * 16)
	self.world:addBlock(15 * 16, 5 * 16)

	self.world:addBlock(11 * 16, 6 * 16)
	self.world:addBlock(11 * 16, 7 * 16)
	self.world:addBlock(11 * 16, 8 * 16)

	self.world:addBlock(15 * 16, 6 * 16)
	self.world:addBlock(15 * 16, 7 * 16)
	self.world:addBlock(15 * 16, 8 * 16)

	self.world:addBlock(11 * 16, 8 * 16)
	self.world:addBlock(12 * 16, 8 * 16)
	self.world:addBlock(13 * 16, 8 * 16)

	local e = Emitter(self.particleFactories[2].generatorFunction)
	e:emitAt(208, 100)
	e:setEmitting(true)
	self.world:addEmitter(e)

	local e = Emitter(self.particleFactories[2].generatorFunction)
	e:emitAt(208, 100)
	e:setEmitting(true)
	-- self.world:addEmitter(e)
end

function StateFragments:mousePressed(x, y, button, istouch, presses)
	if button == 1 then
		if self.statusPlaceBlock then
			self.world:addBlock(x, y)
		else
			-- Create a new Emitter, using the generator function of the current
			-- factory so it starts spewing stuff at the given x,y position.
			local e = Emitter(self.currentParticleFactory.generatorFunction)
			e:emitAt(x, y)
			e:setEmitting(true)
			self.world:addEmitter(e)
		end
	end
end

function StateFragments:mouseReleased(x, y, button, istouch, presses)
end

function StateFragments:mouseMoved(x, y, dx, dy, istouch)
	self.mousePosition = { x = x, y = y }
end

function StateFragments:mouseWheelMoved(x, y)
	self.world:setGridSize(y)
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
		self.world = World()
	end
end

function StateFragments:update(dt)
	-- always reinitialize the grid for now
	if self.paused then return end

	self.world:update(dt)
end

function StateFragments:draw()
	self.world:draw()

	love.graphics.setFont(globals.gameFont)
	love.graphics.setColor(1, 1, 1, 1)
	local debugstr = string.format("FPS: %d\n", love.timer.getFPS())
	debugstr = debugstr .. string.format("KB used: %d\n", collectgarbage("count"))
	debugstr = debugstr .. string.format("Number of particles: %d\n", self.world.spatialGrid.particleCount)

	local cell = self.world.spatialGrid:getCellAt(self.mousePosition.x, self.mousePosition.y)
	local count = self.world.spatialGrid:getParticleCountAt(self.mousePosition.x, self.mousePosition.y)
	debugstr = debugstr .. string.format("Number of particles at (%2d, %2d) = %3d\n", cell.row, cell.col, count)

	if self.statusPlaceBlock then
		debugstr = debugstr .. string.format("PLACING BLOCK\n")
	else
		debugstr = debugstr .. string.format("Current generator: %s\n", self.currentParticleFactory.name)
	end

	if self.paused then
		debugstr = debugstr .. "Paused!\n"
	end

	love.graphics.print(debugstr, 0, 0)

	if self.statusPlaceBlock then
		love.graphics.setColor({1, 1, 1, 1})
		local x = math.floor(self.mousePosition.x / 16.0) * 16.0
		local y = math.floor(self.mousePosition.y / 16.0) * 16.0
		love.graphics.rectangle("line", x, y, 16, 16)
	end
end
