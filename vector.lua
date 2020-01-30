require("class")

Vector = class()

function Vector:_init(x, y)
    self.x = x
    self.y = y
end

function Vector:magnitude()
    return math.sqrt(math.pow(self.x, 2) + math.pow(self.y, 2))
end

-- lerp will do a linear interpolation of both the x and ycomponents of the
-- vector, which can be used to slowly lower or heighten the magnitude of
-- the vector.
function Vector:lerp(v1, t)
    self.x = lerp(self.x, v1, t)
    self.y = lerp(self.y, v1, t)
end

function Vector:__add(other)
    return Vector(self.x + other.x, self.y + other.y)
end

function Vector:__sub(other)
    return Vector(self.x - other.x, self.y - other.y)
end

function Vector:__mul(other)
    if type(other) == "number" then
        return Vector(self.x * other, self.y * other)
    else
        return Vector(self.x * other.x, self.y * other.y)
    end
end

function Vector:__tostring()
    return string.format("Vector (%d, %d)", self.x, self.y)
end
