require("class")
require("spatialgrid")

Particle = class()
function Particle:_init()
    self.x = 20
    self.y = 237
    self.size = 5
end

function Particle:__tostring()
    return string.format("Particle at %d, %d", self.x, self.y)
end

p1 = Particle()
p1.x = 2
p1.y = 2

p2 = Particle()
p2.x = 2
p2.y = 2



g = SpatialGrid()

g:addParticle(p1)
g:addParticle(p2)

g:print()
