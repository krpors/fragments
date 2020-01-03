require("class")
require("util")

StateKaleidoscope = class()

function StateKaleidoscope:_init()
	self.canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())

	self.size = 4

	self.mousePosition = {
		x = 0,
		y = 0,
	}
	self.pressed = false
	self.random = false
	self.direction = {
		x = love.math.random() * 2,
		y = love.math.random() * 2
	}

	self.color = { 1, 1, 1, 1,}

	self.counter = 1
	self.time = 0
end

function StateKaleidoscope:mousePressed(x, y, button, istouch, presses)
	if button == 1 then
		self.pressed = true
	end
end

function StateKaleidoscope:mouseReleased(x, y, button, istouch, presses)
	self.pressed = false
end

function StateKaleidoscope:mouseMoved(x, y, dx, dy, istouch)
	self.pressed = true
	self.mousePosition = { x = x, y = y }
end

function StateKaleidoscope:mouseWheelMoved(x, y)
	self.color = {
		love.math.random(),
		love.math.random(),
		love.math.random(),
		1
	}
end

function StateKaleidoscope:keyPressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'k' then
		self.canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
	elseif key == 'r' then
		self.random = not self.random
	elseif key == '.' then
		self.size = self.size + 1
	elseif key == ',' then
		self.size = self.size - 1
	elseif key == ']' then
		self.color = {
			love.math.random(),
			love.math.random(),
			love.math.random(),
			1
		}
	end
end

function StateKaleidoscope:update(dt)
	self.time = self.time + dt

	if self.time % 2 == 0 then
		self.direction = {
			x = love.math.random() * 2,
			y = love.math.random() * 2
		}
	end

	if self.random then
		self.mousePosition = {
			x = clamp(self.mousePosition.x + self.direction.x, 0, love.graphics.getWidth()),
			y = clamp(self.mousePosition.y + self.direction.y, 0, love.graphics.getHeight())
		}
		-- print(self.mousePosition.x, self.mousePosition.y)
	end
end

function StateKaleidoscope:draw()
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	love.graphics.setCanvas(self.canvas)

	if self.pressed or self.random then

		love.graphics.setColor(self.color)
		love.graphics.circle('fill', self.mousePosition.x, self.mousePosition.y, self.size)
		love.graphics.circle('fill', w - self.mousePosition.x, h - self.mousePosition.y, self.size)
		love.graphics.circle('fill', w - self.mousePosition.x, self.mousePosition.y, self.size)
		love.graphics.circle('fill', self.mousePosition.x,  h - self.mousePosition.y, self.size)
	end

	love.graphics.setCanvas()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.canvas)
end
