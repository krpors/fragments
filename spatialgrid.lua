-- Will represent the collision detection's broad phase spatial grid.
SpatialGrid = class()

function SpatialGrid:_init()
	self.gridSize = 50
	self.mousePosition = {0, 0}
	self.obstacles = {}

	self.particleCount = 0
	self.grid = {}

	self:reinitialize()
end

-- Re-initializes the grid with empty values.
function SpatialGrid:reinitialize()
	self.particleCount = 0

	local maxGridX = love.graphics.getWidth() / self.gridSize
	local maxGridY = love.graphics.getHeight() / self.gridSize

	for row = 1, maxGridY do
		self.grid[row] = {}
		for col = 1, maxGridX do
			self.grid[row][col] = {}
		end
	end
end

function SpatialGrid:addParticle(particle)
	self.particleCount = self.particleCount + 1

	local maxGridX = love.graphics.getWidth() / self.gridSize
	local maxGridY = love.graphics.getHeight() / self.gridSize

	-- 1. check what cells are occupied by this aabb
	-- 2. add into grid[row][cell]
	local minx = math.floor(particle.x / self.gridSize) + 1
	local miny = math.floor(particle.y / self.gridSize) + 1

	local maxx = math.min(maxGridX, math.floor((particle.x + particle.size) / self.gridSize) + 1)
	local maxy = math.min(maxGridY, math.floor((particle.y + particle.size) / self.gridSize) + 1)

	for col = minx, maxx do
		for row = miny, maxy do
			table.insert(self.grid[row][col], particle)
		end
	end
end

function SpatialGrid:checkCollisions()
	local maxGridX = love.graphics.getWidth() / self.gridSize
	local maxGridY = love.graphics.getHeight() / self.gridSize

	for row = 1, maxGridY do
		for col = 1, maxGridX do
			local particles = self.grid[row][col]
			for i = 1, #particles do
				for j = i + 1, #particles do
					local particle1 = particles[i]
					local particle2 = particles[j]
					if particle1:collidesWith(particle2) then
						particle1:handleCollision(particle2)
						particle2:handleCollision(particle1)
					end
				end
			end
		end
	end
end

function SpatialGrid:print()
	local s = ""
	for row = 1, #self.grid do
		for col = 1, #self.grid[1] do
			local z = self.grid[row][col]
			s = s .. string.format("%3d,", #z)
		end

		s = s .. "\n"
	end

	print(s)
end

function SpatialGrid:getCrud()
	return {
		math.floor(self.mousePosition[1] / self.gridSize) * self.gridSize,
		math.floor(self.mousePosition[2] / self.gridSize) * self.gridSize,
		self.gridSize,
		self.gridSize
	}
end

function SpatialGrid:placeObstacle(x, y)
	table.insert(self.obstacles, {x = x, y = y})
end

function SpatialGrid:drawObstacles()
	for i, k in ipairs(self.obstacles) do
		local posx = math.floor(k.x / self.gridSize) * self.gridSize
		local posy = math.floor(k.y / self.gridSize) * self.gridSize
		love.graphics.rectangle("fill", posx, posy, self.gridSize, self.gridSize)
	end
end

function SpatialGrid:draw()
	love.graphics.setColor(0.4, 0.4, 0.4, 0.5)
	love.graphics.setLineStyle("rough")
	love.graphics.setLineWidth(1)

	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()

	for x = 0, w, self.gridSize do
		love.graphics.line(x, 0, x, h)
	end

	for y = 0, h, self.gridSize do
		love.graphics.line(0, y, w, y)
	end

	love.graphics.setColor(1, 1, 1, 1)
	local cursorPos = self:getCrud()
	love.graphics.rectangle("fill", cursorPos[1], cursorPos[2], self.gridSize, self.gridSize)

	self:drawObstacles()
end
