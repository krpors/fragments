-- The file can be used for testing

require("util")

list = {}

for i = 1, 90000 do
	table.insert(list, i)
end

print("================")
table.removeif(list, function(val) return val % 2 == 0 end)
print("================")

for i = 1, #list do
	print(i, list[i])
end
