StateFragments = {}
StateFragments.__index = StateFragments

-- This is the actual Fragments implementation (fluidfun).
function StateFragments:new()
    local self = setmetatable({}, StateFragments)

    return self
end


function StateFragments:mousePressed(x, y, button, istouch, presses)
end

function StateFragments:mouseMoved(x, y, dx, dy, istouch)
end

function StateFragments:keyPressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function StateFragments:update(dt)
end

function StateFragments:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Fragments", 0, 0)
end
