-- Will represent the collision detection's broad phase spatial grid.
SpatialGrid = class()

function SpatialGrid:_init()
	-- Size of the grid (amount of dividers)
	self.gridSize = 4
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

	self.grid = {}

	for row = 1, self.gridSize do
		self.grid[row] = {}
		for col = 1, self.gridSize do
			self.grid[row][col] = {}
		end
	end
end

function SpatialGrid:addParticle(particle)
	self.particleCount = self.particleCount + 1

	-- how many pixels are occopied per column and per row:
	local pixPerColumn = love.graphics.getWidth() / self.gridSize
	local pixPerRow = love.graphics.getHeight() / self.gridSize

	-- determine the cell which is occupied by top-left corner of the entity
	local minx = math.floor(particle.x / pixPerColumn) + 1
	local miny = math.floor(particle.y / pixPerRow) + 1

	-- determine the cell which is occupied by the bottom-right corner:
	local maxx = math.min(self.gridSize, math.floor((particle.x + particle.size) / pixPerColumn) + 1)
	local maxy = math.min(self.gridSize, math.floor((particle.y + particle.size) / pixPerRow) + 1)

	-- add the entity to each occupied cell:
	for col = minx, maxx do
		for row = miny, maxy do
			table.insert(self.grid[row][col], particle)
		end
	end
end

function SpatialGrid:checkCollisions()
	for row = 1, self.gridSize do
		for col = 1, self.gridSize do
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
	print("Gridsize:", self.gridSize)
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

	local incrementw = w / self.gridSize
	for x = 0, w, incrementw do
		love.graphics.line(x, 0, x, h)
	end

	local incrementh = h / self.gridSize
	for y = 0, h, incrementh do
		love.graphics.line(0, y, w, y)
	end

	self:drawObstacles()
end
