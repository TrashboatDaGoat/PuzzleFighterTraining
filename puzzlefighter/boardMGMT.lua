local function piece_change()
	local keys = joypad.get()
	if keys['P1 Up'] then
	local address = 0xFF8455
	local current = memory.readbyte(address)
		if current == 4 then 
		current = 9 elseif 
		current == 12 then
		current = 1 else
		current = current + 1
		end
	memory.writebyte(address, current)
	else
		local address = 0xFF8453
	local current = memory.readbyte(address)
		if current == 4 then 
		current = 9 elseif 
		current == 12 then
		current = 1 else
		current = current + 1
		end
	memory.writebyte(address, current)
	
	
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
["piece_change"]		 = piece_change,
}

return boardMGMT
