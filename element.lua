-- An element contains information for how particles should behave.
-- It is more like meta data, and does not contain any literal behaviour
-- in the form of methods.
--
-- Is it maybe better just to put this as an 'anonymous' table instead?
Element = {}
Element.__index = Element

function Element:new()
	local self = setmetatable({}, Element)

	self.name = "None"
	self.mass = 10
	self.type = "solid"
	self.life = 2
	self.gravity = 9.8
	self.color = {
		hot  = { 1, 0, 0, 1 },
		cool = { 0, 0, 1, 1 },
	}

	return self
end
