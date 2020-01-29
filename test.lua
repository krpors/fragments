require("class")
require("spatialgrid")

require("particles/particle")
require("vector")

v1 = Vector(-1, 2)
v2 = Vector(-4, 1)

print(v1:magnitude())
print(v2:magnitude())

v3 = v1 + v2

print(v3.x, v3.y)
