require("class")
require("spatialgrid")
require("emitter")
require("particles/hydrogen")
require("particles/oxygen")
require("particles/lava")
require("particles/block")

StateTester = class()

function StateTester:_init()
	self.paused = false

	-- The grid which is used for broad-phased collision detection.
	self.spatialGrid = SpatialGrid()

	self.mousePosition = {
		x = 0,
		y = 0,
	}

	-- TODO: fix the bug with the collision left/right. It's doing some weird stuff.

	self.p1 = Lava()
	self.p1.x = 150
	self.p1.y = 500
	self.p1.dx = -150

	self.p2 = Lava()
	self.p2.x = 200
	self.p2.y = 480
	self.p2.dx = -50
	self.p2.color = {1, 0,0, 1}

end

function StateTester:mousePressed(x, y, button, istouch, presses)
end

function StateTester:mouseReleased(x, y, button, istouch, presses)
end

function StateTester:mouseMoved(x, y, dx, dy, istouch)
	self.mousePosition = { x = x, y = y }
	self.spatialGrid.mousePosition = { x, y }
end

function StateTester:mouseWheelMoved(x, y)
	if y > 0 then
		self.spatialGrid.gridSize = self.spatialGrid.gridSize + 1
	elseif y < 0 then
		self.spatialGrid.gridSize = math.max(1, self.spatialGrid.gridSize - 1)
	end

	self.spatialGrid:reinitialize()
end

function StateTester:keyPressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'd' then
		print(self.spatialGrid.particleCount)
		self.spatialGrid:print()
	elseif key == 'b' then
		self.statusPlaceBlock = not self.statusPlaceBlock
	elseif key == 'p' then
		self.paused = not self.paused
	end
end

function StateTester:update(dt)
	-- always reinitialize the grid for now
	if self.paused then return end

	self.spatialGrid:reinitialize()

	self.p1:update(dt)
	self.p2:update(dt)

	self.spatialGrid:addParticle(self.p1)
	self.spatialGrid:addParticle(self.p2)

	self.spatialGrid:checkCollisions()
end

function StateTester:draw()
	self.spatialGrid:draw()

	self.p1:draw()
	self.p2:draw()
end
