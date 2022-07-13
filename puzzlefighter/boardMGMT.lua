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
local function get_bottom_piece()
    local training_options_bottom_piece = globals.training_options.bottom_piece
	local currentPiece = 0x0
    -- If we reordered these I think we wouldn't even need the if/elseif block
    -- e.g I think 0x0A == 10
    if training_options_bottom_piece == 1  then
		currentPiece = 0x01
	elseif training_options_bottom_piece == 2 then
		currentPiece = 0x02
	elseif training_options_bottom_piece == 3 then
		currentPiece = 0x03
	elseif training_options_bottom_piece == 4 then
		currentPiece = 0x04
	elseif training_options_bottom_piece == 5 then
		currentPiece = 0x09
	elseif training_options_bottom_piece == 6 then
		currentPiece = 0x0A
	elseif training_options_bottom_piece == 7 then
		currentPiece = 0x0B
	elseif training_options_bottom_piece == 8 then
		currentPiece = 0x0C
	elseif training_options_bottom_piece == 9 then
		currentPiece = globals.training_options.bottom_piece
	end
    -- Update our local options
    globals.options.p1.bottom_piece = currentPiece
	-- Return for convenience, we could just key into globals.options.p1.currentPattern
	return currentPiece
end

local function get_top_piece()
    local training_options_top_piece = globals.training_options.top_piece
	local currentPiece = 0x0
    -- If we reordered these I think we wouldn't even need the if/elseif block
    -- e.g I think 0x0A == 10
    if training_options_top_piece == 1  then
		currentPiece = 1
	elseif training_options_top_piece == 2 then
		currentPiece = 2
	elseif training_options_top_piece == 3 then
		currentPiece = 3
	elseif training_options_top_piece == 4 then
		currentPiece = 4
	elseif training_options_top_piece == 5 then
		currentPiece = 9
	elseif training_options_top_piece == 6 then
		currentPiece = 10
	elseif training_options_top_piece == 7 then
		currentPiece = 11
	elseif training_options_top_piece == 8 then
		currentPiece = 12
	elseif training_options_top_piece == 9 then
		currentPiece = globals.training_options.top_piece
	end
    -- Update our local options

	-- Return for convenience, we could just key into globals.options.p1.currentPattern
	return currentPiece
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
["get_top_piece"]   	 = get_top_piece,
["get_bottom_piece"]	 = get_bottom_piece,
}

return boardMGMT
