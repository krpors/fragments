require("class")
require("spatialgrid")
require("emitter")
require("hydrogen")
require("oxygen")
require("lava")

StateFragments = class()

-- This is the actual Fragments implementation (fluidfun).
function StateFragments:_init()
	self.emitters = {}
	table.insert(self.emitters, Emitter(function() return Hydrogen() end ))
	table.insert(self.emitters, Emitter(function() return Oxygen() end ))
	table.insert(self.emitters, Emitter(function() return Lava() end ))

	self.paused = false

	self.placedEmitters = {}

	self.nextEmitter = circular_iter(self.emitters)
	self.currentEmitter = self.nextEmitter()

	self.allParticles = {}

	self.spatialGrid = SpatialGrid()

	self.mousePosition = {
		x = 0,
		y = 0,
	}

	self.testParticles = {}

	table.insert(self.testParticles, Lava())
	table.insert(self.testParticles, Lava())

	self.testParticles[1].dx = 20
	self.testParticles[1].x = 100
	self.testParticles[1].y = 100

	self.testParticles[2].dx = 50
	self.testParticles[2].x = 10
	self.testParticles[2].y = 100
end


function StateFragments:mousePressed(x, y, button, istouch, presses)
	-- self.currentEmitter:setEmitting(true)
	if button == 1 then
		local e = Emitter(function() return Hydrogen() end )
		e:emitAt(x, y)
		e:setEmitting(true)
		table.insert(self.placedEmitters, e)
	elseif button == 2 then
		local e = Emitter(function() return Lava() end )
		e:emitAt(x, y)
		e:setEmitting(true)
		table.insert(self.placedEmitters, e)
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
end

function StateFragments:keyPressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == ']'  then
		self.currentEmitter = self.nextEmitter()
	elseif key == 'd' then
		print(self.spatialGrid.particleCount)
		self.spatialGrid:print()
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

	for _, particle in ipairs(self.testParticles) do
		particle:update(dt)

		self.spatialGrid:addParticle(particle)
	end

	for i, emitter in ipairs(self.placedEmitters) do
		emitter:update(dt)

		-- Add all particles to the spatial grid, for the broadphase collision
		-- detection before narrowing it down.
		for i, v in ipairs(emitter.particles) do
			self.spatialGrid:addParticle(v)
		end
	end

	self.spatialGrid:checkCollisions()
end

function StateFragments:draw()
	self.spatialGrid:draw()

	for i, emitter in ipairs(self.placedEmitters) do
		emitter:draw()
	end

	for _, particle in ipairs(self.testParticles) do
		particle:draw()
	end

	love.graphics.setFont(globals.gameFont)
	love.graphics.setColor(1, 1, 1, 1)

	local debugstr = string.format("FPS: %d\n", love.timer.getFPS())
	debugstr = debugstr .. string.format("KB used: %d\n", collectgarbage("count"))
	debugstr = debugstr .. string.format("Number of particles: %d\n", self.spatialGrid.particleCount)

	local cell = self.spatialGrid:getCellAt(self.mousePosition.x, self.mousePosition.y)
	local count = self.spatialGrid:getParticleCountAt(self.mousePosition.x, self.mousePosition.y)
	debugstr = debugstr .. string.format("Number of particles at (%2d, %2d) = %3d\n", cell.row, cell.col, count)

	if self.paused then
		debugstr = debugstr .. "Paused!\n"
	end

	love.graphics.print(debugstr, 0, 0)
end
