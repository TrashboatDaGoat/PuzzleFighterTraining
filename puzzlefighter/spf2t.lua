-- This is how to do modules in lua so you keep your code neat.
-- See bottom of util file for export.
serialize  	            = require './scripts/ser' -- If you print out a table and get funky stuff, use this! print(serialize(mytable))
util                    = require './puzzlefighter/util'
guiModule 		        = require './puzzlefighter/GUI'
menuModule              = require './puzzlefighter/menu'
playerObject            = require './puzzlefighter/playerObject'
configModule            = require './puzzlefighter/config'
training_settings_file  = "training_settings.json"
training_settings       = configModule.default_training_settings

globals = {
    options = {
		in_match = false,
        current_frame = 0,
        training_options = nil,
        menuModule = nil, 
		show_menu = nil,
        p1 = {
            currentPattern = 0x0,
            gemsToDrop = 0x0,
			piecesDropped = 0x00,
			diamondNumber = 0x00,
			
        },
        p2 = {
            currentPattern = 0x0,
            gemsToDrop = 0x0,
			piecesDropped = 0x0,
			diamondNumber = 0x00,
			timePassed = 0x00
        }
    },
}
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

-- Hotkeys (set in menu)
input.registerhotkey(1, function()
    -- print("Send "..globals.options.p2.gemsToDrop.." gems to p2!")
    memory.writebyte(0xFF849E, globals.options.p1.gemsToDrop) -- Send  Gems to P2
	memory.writebyte(0xFF889E, globals.options.p2.gemsToDrop) -- Send gems to P1
end)

--input.registerhotkey(2, function()
    -- print("Send "..globals.options.p2.gemsToDrop.." gems to p1!")
  --  memory.writebyte(0xFF889E, globals.options.p2.gemsToDrop) -- Send 60 Gems to P2
--end)
input.registerhotkey(2, function()
    -- This doesnt need the subtraction. Counterpoint yes it does
	memory.writeword(0xFF84F4, memory.readword(0xFF84F6)-0x01) -- get diamond

end)


-- Drop Pattern for P1
input.registerhotkey(3, function()
    local currentPattern = get_p1_character()
    currentPattern = currentPattern + 1

    if currentPattern > 0x0A then
        currentPattern = 0x00
    end

    globals.training_options.p1_character = currentPattern
    -- Because we want our options to be able to changed by a hotkey
    -- OR a training menu change, we need to save the training data to keep in sync
    util.save_training_data()
end)

-- Drop Pattern for P2
-- Practice: Refactor to use one single function for both p1 or p2 drop pattern changes
input.registerhotkey(4, function()
    local currentPattern = globals.options.p2.currentPattern
    currentPattern = currentPattern + 1

    if currentPattern > 0x0A then
        currentPattern = 0x00
    end

    globals.options.p2.currentPattern = currentPattern
	memory.writebyte(0xFF8382 + 0x400, globals.options.p2.currentPattern)

end)


-- Number of Gems to Drop for p1
input.registerhotkey(5, function()
    local gemsToDrop = globals.options.p1.gemsToDrop
    gemsToDrop = gemsToDrop + 5

    if gemsToDrop > 0x4B then
        gemsToDrop = 0x00
    end

    globals.options.p1.gemsToDrop = gemsToDrop
end)

-- Number of Gems to Drop for p2
input.registerhotkey(6, function()
    local gemsToDrop = globals.options.p2.gemsToDrop
    gemsToDrop = gemsToDrop + 5

    if gemsToDrop > 0x4B then
        gemsToDrop = 0x00
    end

    globals.options.p2.gemsToDrop = gemsToDrop
end)

input.registerhotkey(7, function()

    local gemsToDrop = globals.options.p1.gemsToDrop
    gemsToDrop = gemsToDrop - 5

    if gemsToDrop < 0x00 then
        gemsToDrop = 0x4B
    end

    globals.options.p1.gemsToDrop = gemsToDrop

end)

input.registerhotkey(8, function()

    local gemsToDrop = globals.options.p2.gemsToDrop
    gemsToDrop = gemsToDrop - 5

    if gemsToDrop < 0x00 then
        gemsToDrop = 0x4B
    end

    globals.options.p2.gemsToDrop = gemsToDrop

end)

input.registerhotkey(9, function()
end)

-- Exercise: Move this to the util module

emu.registerstart(function() -- Called when lua is started
    util.load_training_data()
	globals["training_options"] = configModule.registerBefore()
    globals["current_frame"] = emu.framecount()
    
    player_objects = {
		playerObject.make_player_object(1, 0xFF8400, "P1"),
		playerObject.make_player_object(2, 0xFF8800, "P2")
	}
    globals.menuModule = menuModule.registerStart()
    util.print_training_info()
end)

-- You can use this to do something based on the value conditionally
-- See gui.register


emu.registerbefore(function() -- Called before a frame is drawn (e.g. set inputs here)
    globals["current_frame"] = emu.framecount()
    util.handle_hotkeys()
	--in game indicator
	if memory.readword(0xFF8640) > 0 then
	globals.options.in_match = true
	else globals.options.in_match = false
	end
    -- Infinite time on CSS
    
	--Pause piece whenever the menu comes up. look @ menu.lua line 647 for Xref
	--if globals.show_menu == true then
		--menu.piecePause()
		
	end
    if globals.training_options.infinite_time == true then
        memory.writebyte(0xFF8B0E, 0x10) -- P1 Timer never changes
        memory.writebyte(0xFF8B0E + 0x100, 0x10) -- P2 Timer never changes
    end
    -- Set current character
    -- Notice it uses the value from our getter function
    if in_match == true then 
	memory.writebyte(0xFF8382, get_p1_character())
	end
	
	--  to keep the gems floating
	memory.writebyte(0xFF8715, 0x07) --P2
    --memory.writebyte(0xFF8715 - 0x400, 0x07) --P1

	--Keep margin time @ level 1
memory.writeword(0xFF8640, 0x00)
--memory.writeword(0xFF8640 + 0x400, 0x00)
    
   
	--read how many pieces P! has dropped in the game
	globals.options.p1.piecesDropped = memory.readword(0xFF84F4)
    playerObject.read_player_vars(player_objects[1], player_objects[2])
	globals.options.p2.timePassed = memory.readword(0xFF9040)
	
end)
emu.registerafter(function() -- Called after a frame is drawn
end)


--Not As useful
if savestate.registersave and savestate.registerload then --registersave/registerload are unavailable in some emus

	savestate.registersave(function(slot) -- On Save
	end)

	savestate.registerload(function(slot) -- On Load
	end)
end

emu.registerexit(function() -- Called when the script exits, i don't use this
end)


while true do
	gui.register(function() -- This is where gui type things go
        guiModule.draw_gui()
        menuModule.guiRegister()
    end)
    emu.frameadvance() -- Do not remove this!
end