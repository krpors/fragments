require("class")
require("spatialgrid")
require("emitter")
require("particles/hydrogen")
require("particles/oxygen")
require("particles/lava")
require("particles/block")
local vec2 = require("vec2")

StateDerp = class()

function StateDerp:_init()
	self.spatialGrid = SpatialGrid()

	self.balls = {}

	self.gravity = vec2(0, 2000)
	local minradius = 20
	local maxradius = 40

	for i = 0, 30 do
		local radius = love.math.random(10, 50)
		local pos = vec2(love.math.random(radius, 800 - radius), love.math.random(radius, 600 - radius))
		local ball = {
			prevpos = pos,
			pos = pos,
			radius = radius,
			mass = radius * radius,
		}
		table.insert(self.balls, ball)
	end
end

function StateDerp:mousePressed(x, y, button, istouch, presses)
end

function StateDerp:mouseReleased(x, y, button, istouch, presses)
end

function StateDerp:mouseMoved(x, y, dx, dy, istouch)
end

function StateDerp:mouseWheelMoved(x, y)
	if y > 0 then
		self.spatialGrid.gridSize = self.spatialGrid.gridSize + 1
	elseif y < 0 then
		self.spatialGrid.gridSize = math.max(1, self.spatialGrid.gridSize - 1)
	end

	self.spatialGrid:reinitialize()
end

function StateDerp:keyPressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function StateDerp:update(dt)
	-- always reinitialize the grid for now
	self.spatialGrid:reinitialize()

	-- Verlet:
	for _, ball in ipairs(self.balls) do
		ball.prevpos = ball.pos
		ball.pos = 2 * ball.pos - ball.prevpos + dt * dt * self.gravity
	end

	-- Constraints:
	for _, ball in ipairs(self.balls) do
		-- local a2b = (ball.pos )
	end

	self.spatialGrid:checkCollisions()
end

function StateDerp:draw()
	self.spatialGrid:draw()

	for _, ball in ipairs(self.balls) do
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.circle("fill", ball.pos.x, ball.pos.y, ball.radius)
	end
end
