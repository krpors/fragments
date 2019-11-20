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
