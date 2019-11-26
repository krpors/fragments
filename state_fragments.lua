require("class")
require("emitter")
require("hydrogen")

StateFragments = class()

-- This is the actual Fragments implementation (fluidfun).
function StateFragments:_init()
	self.emitters = {}
	table.insert(self.emitters, Emitter(function() return Hydrogen() end ))

	self.nextEmitter = circular_iter(self.emitters)
	self.currentEmitter = self.nextEmitter()
end


function StateFragments:mousePressed(x, y, button, istouch, presses)
	self.currentEmitter:setEmitting(true)
end

function StateFragments:mouseReleased(x, y, button, istouch, presses)
	self.currentEmitter:setEmitting(false)
end

function StateFragments:mouseMoved(x, y, dx, dy, istouch)
	self.currentEmitter:emitAt(x, y)
end

function StateFragments:keyPressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == ']'  then
		self.currentEmitter = self.nextEmitter()
	end
end

function StateFragments:update(dt)
	self.currentEmitter:update(dt)

	for _, particle1 in ipairs(self.currentEmitter.particles) do
		for _, particle2 in ipairs(self.currentEmitter.particles) do
			if particle1 ~= particle2 then
				if particle1:collidesWith(particle2) then
					-- particle2:moveInRandomDirection()
					particle1:handleCollision(particle2)
					particle2:handleCollision(particle1)
				end
			end
		end
	end
end

function StateFragments:draw()
	love.graphics.setFont(globals.gameFont)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Fragments", 0, 0)
	love.graphics.print("# of particles: " .. #self.currentEmitter.particles, 0, 10)
	local s = ""
	local max = 1
	for _, p in ipairs(self.currentEmitter.particles) do
		s = s .. string.format("%s\n", p)
		max = max + 1
		if max >= 10 then
			s = s .. "(...)"
			break
		end
	end

	love.graphics.print(s, 0, 20)
	self.currentEmitter:draw()
end
