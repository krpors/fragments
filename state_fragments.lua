require "emitter"

StateFragments = {}
StateFragments.__index = StateFragments

-- This is the actual Fragments implementation (fluidfun).
function StateFragments:new()
    local self = setmetatable({}, StateFragments)

    self.emitter = Emitter:new()

    return self
end


function StateFragments:mousePressed(x, y, button, istouch, presses)
    self.emitter:setEmitting(true)
end

function StateFragments:mouseReleased(x, y, button, istouch, presses)
    self.emitter:setEmitting(false)
end

function StateFragments:mouseMoved(x, y, dx, dy, istouch)
    self.emitter:emitAt(x, y)
end

function StateFragments:keyPressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function StateFragments:update(dt)
    self.emitter:update(dt)
end

function StateFragments:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Fragments", 0, 0)
    love.graphics.print("# of particles: " .. #self.emitter.particles, 0, 10)

    self.emitter:draw()
end
