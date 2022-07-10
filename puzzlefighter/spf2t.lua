-- This is how to do modules in lua so you keep your code neat.
-- See bottom of util file for export.
serialize  	            = require './puzzlefighter/ser' -- If you print out a table and get funky stuff, use this! print(serialize(mytable))
util                    = require './puzzlefighter/util'
guiModule 		        = require './puzzlefighter/GUI'
menuModule              = require './puzzlefighter/menu'
playerObject            = require './puzzlefighter/playerObject'
configModule            = require './puzzlefighter/config'
bMGMT					= require './puzzlefighter/boardMGMT'
training_settings_file  = "training_settings.json"
training_settings       = configModule.default_training_settings

globals = {
		state = {
	        in_match = false,
            timePassed = 0x00,
            gameTime = 0x00,
	    },
	    options = {
    		current_frame = 0,
            training_options = nil,
            menuModule = nil, 
		    show_menu = false,
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
            }
    },
}


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


local function get_margin_time()
	local training_options_margin_time = globals.training_options.margin_time
	local gameTime = globals.state.gameTime
	
	if training_options_margin_time == 1 then
		gameTime = 0x02
	elseif training_options_margin_time == 2 then
		gameTime = 0x4C
	elseif training_options_margin_time == 3 then
		gameTime = 0x6A
	elseif training_options_margin_time == 4 then
		gameTime = 0x88
	elseif training_options_margin_time == 5 then
		gameTime = 0xA6
	elseif training_options_margin_time == 6 then
		gameTime = 0xC4
	elseif training_options_margin_time == 7 then
		gameTime = 0xE2
	elseif training_options_margin_time == 8 then
		gameTime = 0x100
	elseif training_options_margin_time == 9 then
		gameTime = 0x11E
	elseif training_options_margin_time == 10 then
		gameTime = 0x13C
	elseif training_options_margin_time == 11 then
		gameTime = 0x15A
	elseif training_options_margin_time == 12 then
		gameTime = 0x178
	elseif training_options_margin_time == 13 then
		gameTime = 0x196
	elseif training_options_margin_time == 0 then
		gameTime = 0x01
	end
	globals.state.gameTime = gameTime	

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

-- Hotkeys (set in menu)
input.registerhotkey(1, function()
    local keys = joypad.get()
    -- print(serialize(keys))
    if keys['P1 Up'] then 
        --Do your thang here if up was pressed
        print("Up was pressed while 1 was pressed")
		memory.writebyte(0xFF849E, globals.options.p2.gemsToDrop) -- Send gems to P2
    else
        print("Up was not pressed while 5 was pressed")
		memory.writebyte(0xFF889E, globals.options.p1.gemsToDrop) -- Send  Gems to P1
    end
end)
--input.registerhotkey(2, function()
    -- print("Send "..globals.options.p2.gemsToDrop.." gems to p1!")
  --  memory.writebyte(0xFF889E, globals.options.p2.gemsToDrop) -- Send 60 Gems to P2
--end)
input.registerhotkey(2, function()
    -- This doesnt need the subtraction. Counterpoint yes it does
	memory.writeword(0xFF84F4, memory.readword(0xFF84F6)-0x01) -- get diamond

end)

-- Number of Gems to Drop for p1
input.registerhotkey(3, function()

end)

-- Number of Gems to Drop for p2
input.registerhotkey(4, function()
    
end)

input.registerhotkey(5, function()

end)

input.registerhotkey(6, function()

end)

input.registerhotkey(7, function()
bMGMT.all_clear_gaming()
end)

input.registerhotkey(8, function()

end)
input.registerhotkey(9, function()
end)

local ran_margin_time_once = false
function no_diamond()
	if memory.readword(0xFF84F4) == memory.readword(0xFF84F6) - 2 then
	memory.writeword(0xFF84F4, memory.readword(0xFF84F6))
end

end
function set_margin_time()
    -- Uncomment this line to debug
    -- print("Timer is at", memory.readword(0xFF8640))
    if globals.training_options.margin_fix == true then
        get_margin_time()
        --adjust margin time with settings
        memory.writeword(0xFF8640, globals.state.gameTime)
        ran_margin_time_once = false
    else if globals.training_options.margin_fix == false and ran_margin_time_once == false then 
        memory.writeword(0xFF8640, globals.state.gameTime)
        ran_margin_time_once = true
        end
    end
end

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
	globals.state.in_match = true
	else globals.state.in_match = false
	end
    -- Infinite time on CSS
	  if globals.training_options.infinite_time == true then
        memory.writebyte(0xFF8B0E, 0x10) -- P1 Timer never changes
        memory.writebyte(0xFF8B0E + 0x100, 0x10) -- P2 Timer never changes
		end
	--Pause piece whenever the menu comes up. look @ menu.lua line 647 for Xref
	if globals.show_menu == true then
		menuModule.piecePause()
	end
  
    
    -- Set current character
    -- Notice it uses the value from our getter function
    if globals.state.in_match == true then 
	    memory.writebyte(0xFF8382, get_p1_character())
	end
	 if globals.state.in_match == true then 
	    memory.writebyte(0xFF8782, get_p2_character())
	end
	--  to keep the gems floating
	memory.writebyte(0xFF8715, 0x01) --P2
    --memory.writebyte(0xFF8715 - 0x400, 0x07) --P1
    -- get gameTime

    set_margin_time()
-- if  memory.readword(0xFF8640) > (globals.options.p1.gameTime + 0x1A) and globals.options.p1.marginFix == true then
--         print("Setting")
--         memory.writeword(0xFF8640, globals.options.p1.gameTime)
-- end
	if globals.training_options.no_diamond == true then
	no_diamond()
	end

	get_p1_send_gems()
    get_p2_send_gems()
   
	--read how many pieces P! has dropped in the game
	globals.options.p1.piecesDropped = memory.readword(0xFF84F4)
    playerObject.read_player_vars(player_objects[1], player_objects[2])
	globals.state.timePassed = memory.readword(0xFF8640)
	
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
