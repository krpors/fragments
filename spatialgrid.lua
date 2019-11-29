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

-- Get cell at a specific x,y position on the screen, based on the grid size.
function SpatialGrid:getCellAt(x, y)
	-- how many pixels are occopied per column and per row:
	local pixPerColumn = love.graphics.getWidth() / self.gridSize
	local pixPerRow = love.graphics.getHeight() / self.gridSize

	local tx = math.floor(x / pixPerColumn) + 1
	local ty = math.floor(y / pixPerRow) + 1

	return {
		row = ty,
		col = tx
	}
end

function SpatialGrid:addParticle(particle)
	self.particleCount = self.particleCount + 1

	-- cell at the topleft
	local min = self:getCellAt(particle.x, particle.y)
	-- cell at the bottom right
	local max = self:getCellAt(particle.x + particle.size, particle.y + particle.size)

	-- Don't go out of bounds.
	max.col = math.min(self.gridSize, max.col)
	max.row = math.min(self.gridSize, max.row)

	-- add the entity to each occupied cell:
	for col = min.col, max.col do
		for row = min.row, max.row do
			table.insert(self.grid[row][col], particle)
		end
	end
end

function SpatialGrid:checkCollisions()
	-- Iterate through every cell in the grid
	for row = 1, self.gridSize do
		for col = 1, self.gridSize do
			-- Check which particles are in this cell.
			local particles = self.grid[row][col]
			-- Do the narrow-phase collision detection in each cell.
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

function SpatialGrid:getParticleCountAt(x, y)
	local cell = self:getCellAt(x, y)

	-- BUG: when pausing, then mousewheeling, this will index a nil value.
	-- Probably because the grid is not reinitialized with new values.
	return #self.grid[cell.row][cell.col]
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

-- For debugging purposes: draw the densities of each cell in the grid.
function SpatialGrid:drawDensities()
	-- #self.grid[cell.row][cell.col]
	local gridw = love.graphics.getWidth() / self.gridSize
	local gridh = love.graphics.getHeight() / self.gridSize
	for row = 0, self.gridSize - 1 do
		for col = 0, self.gridSize - 1 do
			local x1 = col * gridw
			local y1 = row * gridh

			local particles = #self.grid[row+1][col+1]
			local densityPercentage = particles / self.particleCount

			love.graphics.setColor({ densityPercentage, 0, 0 , 1})
			love.graphics.rectangle('fill', x1, y1, gridw, gridh)
		end
	end
end

function SpatialGrid:drawGrid()
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
end

function SpatialGrid:draw()
	-- self:drawDensities()
	self:drawGrid()
	self:drawObstacles()
end
