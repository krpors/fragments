--- Generates a circular iterator over a table `t'.
--
-- Usage:
--  local t = {10, 20, 30}
--  local it = circular_iter(t)
--  print(it())
--  print(it())
--  print(it())
--  print(it())
--
-- @param t The table to iterate over.
function circular_iter(t)
	local i = 0
	local n = #t
	return function()
		i = i + 1
		if i > n then
			i = 1
		end
		if i <= n then
			return t[i]
		end
	end
end

-- Linear interpolation function to smooth out movement.
function lerp(v0, v1, t)
	return (1 - t) * v0 + t * v1;
end

-- Clamp the given `val' between the `min` and `max' values. For example,
-- `clamp(-12, 0, 255)' will return 0, and `clamp(933, 0, 255)' will return 255.
function clamp(val, min, max)
	if val < min then
		return min
	elseif val > max then
		return max
	end
	return val
end

-- The builtin table.remove is unperformant and we therefore use our own tiny
-- algorithm to remove items from the table that adhere to conditions.
-- To use this:
--
-- 	list = {}
-- 	for i = 1, 90000 do
-- 		table.insert(list, i)
-- 	end
--
-- 	table.removeif(list, function(val) return val % 2 == 0 end)
function table.removeif(list, removefunc)
	local removeindex = 0

	for i = 1, #list do
		-- Check using the function whether it returns true for the given table
		-- value. If so, that means we have to keep the value. If not, we have
		-- to remove it. Also, already nil values should be marked for 'removal'.
		if removefunc(list[i]) or list[i] == nil then
			-- The current list item should not be kept. Remove it by marking
			-- the index with nil, and assign the new removal index.
			list[i] = nil
			removeindex = removeindex + 1
		else
			-- We check here whether it's necessary to swap elements
			if i ~= removeindex and removeindex > 0 then
				-- Subtract the current iteration index with the removeindex
				-- to get the proper target index for the to-be-kept element
				list[i - removeindex] = list[i]
				-- We have swapped, so set the 'old' keep-element to nil.
				list[i] = nil
			end
		end
	end
end

function table.copyinto(existingtable, othertable)
	for i, v in ipairs(othertable) do
		table.insert(existingtable, v)
	end
end
