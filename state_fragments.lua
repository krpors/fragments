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
end

function StateFragments:keyPressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == ']'  then
		self.currentEmitter = self.nextEmitter()
	elseif key == 'k' then
		print(collectgarbage("count"))
		for i, v in ipairs(self.placedEmitters) do
			print("Nilling")
			v = nil
		end
		print(collectgarbage("count"))
	end
end

function StateFragments:update(dt)
	self.allParticles = {}
	self.spatialGrid:reinitialize()

	for i, emitter in ipairs(self.placedEmitters) do
		emitter:update(dt)

		-- Insert all particle refs into a big giant array so we can easily
		-- do collision detection...
		for i, v in ipairs(emitter.particles) do
			self.spatialGrid:addParticle(v)
		end
		-- table.copyinto(self.allParticles, emitter.particles)
	end

	self.spatialGrid:print()

	-- for _, p1 in ipairs(self.allParticles) do
	-- 	for _, p2 in ipairs(self.allParticles) do
	-- 		if p1 ~= p2 then
	-- 			if p1:collidesWith(p2) then
	-- 				p1:handleCollision(p2)
	-- 				p2:handleCollision(p1)
	-- 			end
	-- 		end
	-- 	end
	-- end
end

function StateFragments:draw()
	for i, emitter in ipairs(self.placedEmitters) do
		emitter:draw()
	end

	love.graphics.setFont(globals.gameFont)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("FPS: " .. love.timer.getFPS())
	love.graphics.print("KB used: " .. collectgarbage("count"), 0, 10)
	love.graphics.print("Fragments", 0, 20)
	love.graphics.print("# of particles: " .. #self.allParticles, 0, 30)
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
end
