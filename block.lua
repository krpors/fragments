require("class")

-- Block is just a block which can be placed on the map to contain particles
-- and crap. It is 'compliant' with the particle 'interface', but does not
-- have any logic. Yet.
Block = class()

function Block:_init()
    self.name = "Block"

    self.size = 16
    self.x = 0
    self.y = 0

    self.color = { 1, 0.5, 0.2, 1}
end

function Block:handleCollision(otherParticle)
    -- this particle does not have logic for collision
end

function Block:collidesWith(otherParticle)
end

function Block:update(dt)
end

function Block:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end
