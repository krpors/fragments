-- An element contains information for how particles should behave.
-- It is more like meta data, and does not contain any literal behaviour
-- in the form of methods.
--
-- Is it maybe better just to put this as an 'anonymous' table instead?
Element = {}
Element.__index = Element

function Element:new()
	local self = setmetatable({}, Element)

	-- Name of the element. Just a description.
	self.name = "None"
	-- Gravity modifier for the element.
	self.mass = 9.8
	-- Lifetime for an element particle.
	self.life = 2
	-- Color parameter.
	self.color = {
		cool = { 0, 0, 1, 1 },
		hot  = { 1, 0, 0, 1 },
	}

	return self
end
