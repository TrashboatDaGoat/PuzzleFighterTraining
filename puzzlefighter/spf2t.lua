-- This is how to do modules in lua so you keep your code neat.
-- See bottom of util file for export.
local util              = require './puzzlefighter/util'
--local gui 				= require './puzzlefighter/gui'

globals = {
    options = {
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
	memory.writebyte("0xFF889E", globals.options.p2.gemsToDrop) -- Send gems to P1
end)

--input.registerhotkey(2, function()
    -- print("Send "..globals.options.p2.gemsToDrop.." gems to p1!")
  --  memory.writebyte(0xFF889E, globals.options.p2.gemsToDrop) -- Send 60 Gems to P2
--end)
input.registerhotkey(2, function()

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
    util.print_training_info()
end)

emu.registerbefore(function() -- Called before a frame is drawn (e.g. set inputs here)

    -- Infinite time on CSS
    memory.writebyte(0xFF8B0E, 0x10) -- P1 Timer never changes
    memory.writebyte(0xFF8B0E + 0x100, 0x10) -- P2 Timer never changes
	
	--  to keep the gems floating
	memory.writebyte(0xFF8715, 0x07) --P2
    --memory.writebyte(0xFF8715 - 0x400, 0x07) --P1

	--Keep margin time @ level 1
--memory.writeword(0xFF8640, 0x00)
--memory.writeword(0xFF8640 + 0x400, 0x00)
    
   
	globals.options.p1.piecesDropped = memory.readword(0xFF84F4)
	
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
       -- Practice -- Refactor this to a module
        -- x, y, text, color
        -- use .. to combine text
        local base_y = 64
        local p1_base_x = 117
        local p2_offset = 80
        local p2_base_x = p1_base_x + p2_offset
        -- Note: color is 0xRRGGBBAA (Red Green Blue alpha, values 0 to FF (0-255))
        gui.box( p1_base_x - 3, base_y - 3, p1_base_x + 150, base_y + 42, 0x00000088)
        gui.text(p1_base_x,base_y, "P1 Char: "..util.get_character_name_from_hex( globals.options.p1.currentPattern ), "green")
        gui.text(p1_base_x,base_y + 8, "P1 Drop #: "..globals.options.p1.gemsToDrop, "red")
		gui.text(p1_base_x,base_y + 16, "P1 Pieces Dropped: "..globals.options.p1.piecesDropped, "yellow" )
		gui.text(p1_base_x,base_y + 24, "P1 Diamond #: "..memory.readword(0xFF84F8), "yellow" )
        gui.text(p2_base_x,base_y, "P2 Char: "..util.get_character_name_from_hex( globals.options.p2.currentPattern ), "green")
        gui.text(p2_base_x,base_y + 8, "P2 Drop #: "..globals.options.p2.gemsToDrop, "red")
		
    
    end)
    emu.frameadvance() -- Do not remove this!
end



