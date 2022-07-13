local function get_p1_send_gems()
	local gemsToDrop = globals.training_options.p1_send_gems
	
	globals.options.p1.gemsToDrop = gemsToDrop
	return gemsToDrop
end

local function get_p2_send_gems()
	local gemsToDrop = globals.training_options.p2_send_gems
	
	globals.options.p2.gemsToDrop = gemsToDrop
	return gemsToDrop
end

function no_diamond()
	if memory.readword(0xFF84F4) == memory.readword(0xFF84F6) - 2 then
	memory.writeword(0xFF84F4, memory.readword(0xFF84F6))
end

end

-- Remember all that this function does is map the number value from the menu
-- To a hex for a pattern, use it when doing memory.writebyte()
-- To do, move these types of functions to another file
local function get_p1_character()
    local training_options_p1_character = globals.training_options.p1_character
	local currentPattern = globals.options.p1.currentPattern
    -- If we reordered these I think we wouldn't even need the if/elseif block
    -- e.g I think 0x0A == 10
    if training_options_p1_character == 1  then
		currentPattern = 0x00
	elseif training_options_p1_character == 2 then
		currentPattern = 0x01
	elseif training_options_p1_character == 3 then
		currentPattern = 0x02
	elseif training_options_p1_character == 4 then
		currentPattern = 0x03
	elseif training_options_p1_character == 5 then
		currentPattern = 0x04
	elseif training_options_p1_character == 6 then
		currentPattern = 0x05
	elseif training_options_p1_character == 7 then
		currentPattern = 0x06
	elseif training_options_p1_character == 8 then
		currentPattern = 0x07
	elseif training_options_p1_character == 9 then
		currentPattern = 0x08
	elseif training_options_p1_character == 10 then
		currentPattern = 0x09
	elseif training_options_p1_character == 11 then
		currentPattern = 0x0A
	elseif training_options_p1_character == 12 then
		currentPattern = globals.options.p1.currentPattern
	end
    -- Update our local options
    globals.options.p1.currentPattern = currentPattern
	-- Return for convenience, we could just key into globals.options.p1.currentPattern
	return currentPattern
end

local function get_p2_character()
    local training_options_p2_character = globals.training_options.p2_character
	local currentPattern = globals.options.p2.currentPattern
    -- If we reordered these I think we wouldn't even need the if/elseif block
    -- e.g I think 0x0A == 10
    if training_options_p2_character == 1  then
		currentPattern = 0x00
	elseif training_options_p2_character == 2 then
		currentPattern = 0x01
	elseif training_options_p2_character == 3 then
		currentPattern = 0x02
	elseif training_options_p2_character == 4 then
		currentPattern = 0x03
	elseif training_options_p2_character == 5 then
		currentPattern = 0x04
	elseif training_options_p2_character == 6 then
		currentPattern = 0x05
	elseif training_options_p2_character == 7 then
		currentPattern = 0x06
	elseif training_options_p2_character == 8 then
		currentPattern = 0x07
	elseif training_options_p2_character == 9 then
		currentPattern = 0x08
	elseif training_options_p2_character == 10 then
		currentPattern = 0x09
	elseif training_options_p2_character == 11 then
		currentPattern = 0x0A
	elseif training_options_p2_character == 12 then
		currentPattern = globals.options.p2.currentPattern
	end
    -- Update our local options
    globals.options.p2.currentPattern = currentPattern
	-- Return for convenience, we could just key into globals.options.p1.currentPattern
	return currentPattern
end


menuFunctions = {

["get_p1_send_gems"]     = get_p1_send_gems,
["get_p2_send_gems"]     = get_p2_send_gems,
["no_diamond"]			 = no_diamond,
["get_p1_character"]	 = get_p1_character,
["get_p2_character"]	 = get_p2_character,
}

return menuFunctions