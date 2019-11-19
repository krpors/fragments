require("emitter")
require("element")

StateFragments = {}
StateFragments.__index = StateFragments

-- This is the actual Fragments implementation (fluidfun).
function StateFragments:new()
    local self = setmetatable({}, StateFragments)

    local water = Element:new()
    water.name = "Water"
    water.mass = 1
    water.type = "liquid"
    water.life = 2

    self.emitter = Emitter:new()
    self.emitter.setElement(water)

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
