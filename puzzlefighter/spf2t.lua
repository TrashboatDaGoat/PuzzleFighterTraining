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
        current_frame = 0,
        training_options = nil,
        menuModule = nil, 
        p1 = {
            currentPattern = 0x0,
            gemsToDrop = 0x0,
			piecesDropped = 0x0,
			diamondNumber = 0x00
        },
        p2 = {
            currentPattern = 0x0,
            gemsToDrop = 0x0,
			piecesDropped = 0x0,
			diamondNumber = 0x00
        }
    },
}
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
    -- This doesnt need the subtraction
	memory.writeword(0xFF84F4, memory.readword(0xFF84F6)-0x01) -- get diamond

end)


-- Drop Pattern for P1
input.registerhotkey(3, function()
    local currentPattern = globals.options.p1.currentPattern
    currentPattern = currentPattern + 1

    if currentPattern > 0x0A then
        currentPattern = 0x00
    end

    globals.options.p1.currentPattern = currentPattern
	memory.writebyte(0xFF8382, globals.options.p1.currentPattern)
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
local pedagogical_list_state = nil
local function get_pedagogical_list()

	current_pedagogical_list_value = globals.training_options.pedagogical_list
	if current_pedagogical_list_value == 1  then
		pedagogical_list_state = "doing something with sample list 1"
	elseif current_pedagogical_list_value == 2 then
		pedagogical_list_state = "doing something with sample list 2"
	elseif current_pedagogical_list_value == 3 then
		pedagogical_list_state = "doing something with sample list 3"
	elseif current_pedagogical_list_value == 4 then
		pedagogical_list_state = "doing something with sample list 4"
	end
	
	return pedagogical_list_state
end

emu.registerbefore(function() -- Called before a frame is drawn (e.g. set inputs here)
    globals["current_frame"] = emu.framecount()
    util.handle_hotkeys()
    -- Infinite time on CSS
    
    if globals.training_options.infinite_time == true then
        memory.writebyte(0xFF8B0E, 0x10) -- P1 Timer never changes
        memory.writebyte(0xFF8B0E + 0x100, 0x10) -- P2 Timer never changes
    end
	--  to keep the gems floating
	memory.writebyte(0xFF8715, 0x07) --P2
    --memory.writebyte(0xFF8715 - 0x400, 0x07) --P1

	--Keep margin time @ level 1
--memory.writeword(0xFF8640, 0x00)
--memory.writeword(0xFF8640 + 0x400, 0x00)
    
   
	globals.options.p1.piecesDropped = memory.readword(0xFF84F4)
    playerObject.read_player_vars(player_objects[1], player_objects[2])

	
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



