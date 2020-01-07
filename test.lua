require("class")
require("spatialgrid")

require("particles/particle")

Particle = class()
function Particle:hello()
    print("hello from partricle")
end
Stuff = class(Particle)
function Stuff:hello()
    print("asdasds")
end

a = Particle()

s = Stuff()
s:hello()
