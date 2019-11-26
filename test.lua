require("class")
-- The file can be used for testing

BaseClass = {}
BaseClass.__index = BaseClass

function BaseClass.new()
	local self = setmetatable({}, BaseClass)
	return self
end

function BaseClass:hello()
	print ("From base class")
end

local DerivedClass = {}
DerivedClass.__index = DerivedClass

function DerivedClass.new()
	setmetatable(DerivedClass, {
		__index = BaseClass,
	})
	local self = setmetatable({}, DerivedClass)
	return self
end

-- function DerivedClass:hello()
-- 	print ("From derived")
-- end

local d = DerivedClass.new()
print(d)
d:hello()

local z = DerivedClass.new()
print(z)
z:hello()


print("====")

local Bla = class()
function Bla:hello()
	print("From Blas")
end

local Derp = class(Bla)
function Derp:hello()
	print("From derp")
end

local d = Derp()
d:hello()
