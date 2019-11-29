require("class")
require("spatialgrid")

Particle = class()
function Particle:hello()
    print("hello from partricle")
end
Stuff = class(Particle)
function Stuff:hello()
    print("asdasds")
end


s = Stuff()
s:hello()
