Grid = {}
Grid.__index = Grid

function Grid:new()
	local self = setmetatable({}, Grid)
	self.gridSize = 10
	self.mousePosition = { 0, 0 }
	self.obstacles = {}
	return self
end

function Grid:getCrud()
	return {
		math.floor(self.mousePosition[1] / self.gridSize) * self.gridSize,
		math.floor(self.mousePosition[2] / self.gridSize) * self.gridSize,
		self.gridSize,
		self.gridSize,
	}
end

function Grid:placeObstacle(x, y)
	table.insert(self.obstacles, { x = x, y = y })
end

function Grid:drawObstacles()
	for i, k in ipairs(self.obstacles) do
		local posx = math.floor(k.x / self.gridSize) * self.gridSize
		local posy = math.floor(k.y / self.gridSize) * self.gridSize
		love.graphics.rectangle('fill', posx, posy, self.gridSize, self.gridSize)
	end
end

function Grid:draw()
	love.graphics.setColor(0.4, 0.4, 0.4, 0.5)
	love.graphics.setLineStyle('rough')
	love.graphics.setLineWidth(1)

	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()

	for x = 0, w, self.gridSize do
		love.graphics.line(x, 0 , x, h)
	end

	for y = 0, h, self.gridSize do
		love.graphics.line(0, y, w, y)
	end

	love.graphics.setColor(1, 1, 1, 1)
	local cursorPos = self:getCrud()
	love.graphics.rectangle('fill', cursorPos[1], cursorPos[2], self.gridSize, self.gridSize)

	self:drawObstacles()
end
