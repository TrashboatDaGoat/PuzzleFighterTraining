local pressed = false
local function piece_change()
local keys = input.get()
if keys['V'] then
  if not pressed then
    local address = keys['7'] and 0x00FF8455 or 0x00FF8453
    pressed = true
    local current = memory.readbyte(address)
    if current == 4 then
	current = 9
elseif current == 12 then
  current = 1
else
  current = current + 1
end
    memory.writebyte(address, current)
  end
else
  pressed = false
end
end
local function all_clear_gaming()
	local address = 0xFFAB03
		for i = 0, 208, 16 do
			for j = 0, 10, 2 do
        memory.writebyte(address + i + j, 0x0)
			end
		end

end
boardMGMT = {
["all_clear_gaming"]     = all_clear_gaming,
}

return boardMGMT
