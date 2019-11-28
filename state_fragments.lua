require("class")
require("spatialgrid")
require("emitter")
require("hydrogen")
require("oxygen")

StateFragments = class()

-- This is the actual Fragments implementation (fluidfun).
function StateFragments:_init()
	self.emitters = {}
	table.insert(self.emitters, Emitter(function() return Hydrogen() end ))
	table.insert(self.emitters, Emitter(function() return Oxygen() end ))

	self.paused = false

	self.placedEmitters = {}

	self.nextEmitter = circular_iter(self.emitters)
	self.currentEmitter = self.nextEmitter()

	self.allParticles = {}

	self.spatialGrid = SpatialGrid()
end


function StateFragments:mousePressed(x, y, button, istouch, presses)
	-- self.currentEmitter:setEmitting(true)
	local e = Emitter(function() return Hydrogen() end )
	e:emitAt(x, y)
	e:setEmitting(true)
	table.insert(self.placedEmitters, e)
end

function StateFragments:mouseReleased(x, y, button, istouch, presses)
end

function StateFragments:mouseMoved(x, y, dx, dy, istouch)
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

	-- self.spatialGrid:print()
	self.spatialGrid:checkCollisions()
end

function StateFragments:draw()
	self.spatialGrid:draw()

	for i, emitter in ipairs(self.placedEmitters) do
		emitter:draw()
	end

	love.graphics.setFont(globals.gameFont)
	love.graphics.setColor(1, 1, 1, 1)

	local debugstr = string.format("FPS: %d\n", love.timer.getFPS())
	debugstr = debugstr .. string.format("KB used: %d\n", collectgarbage("count"))
	debugstr = debugstr .. string.format("Number of particles: %d\n", self.spatialGrid.particleCount)
	if self.paused then
		debugstr = debugstr .. "Paused!\n"
	end
	-- debugstr = debugstr .. "Particles at\n" .. self:spatialGrid:

	love.graphics.print(debugstr, 0, 0)
end
