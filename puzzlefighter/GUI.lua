function draw_gui()
    -- x, y, text, color
    -- use .. to combine text
    if globals.training_options.show_display then
        local base_y = 64
        local p1_base_x = 117
        local p2_offset = 80
        local p2_base_x = p1_base_x + p2_offset
        -- Note: color is 0xRRGGBBAA (Red Green Blue alpha, values 0 to FF (0-255))
        gui.box( p1_base_x - 3, base_y - 3, p1_base_x + 150, base_y + 42, 0x00000088)
        gui.text(p1_base_x,base_y, "P1 Char: "..util.get_character_name_from_hex(memory.readbyte(0xFF8382) ), "green")
        gui.text(p1_base_x,base_y + 8, "P1 Drop #: "..globals.options.p1.gemsToDrop, "red")
        gui.text(p1_base_x,base_y + 16, "P1 Pieces Dropped: "..globals.options.p1.piecesDropped, "yellow" )
        gui.text(p1_base_x,base_y + 24, "P1 Diamond #: "..memory.readword(0xFF84F8), "yellow" )
        gui.text(p2_base_x,base_y, "P2 Char: "..util.get_character_name_from_hex(memory.readbyte(0xFF8382)), "green")
        gui.text(p2_base_x,base_y + 8, "P2 Drop #: "..globals.options.p2.gemsToDrop, "red")
   end
end
	
guiModule = {
    ["draw_gui"] = draw_gui,
}

return guiModule