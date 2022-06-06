local function get_character_name_from_hex( hex )
    if     hex == 0x00 then return "Morrigan"
    elseif hex == 0x01 then return "Chun-Li"
    elseif hex == 0x02 then return "Ryu"
    elseif hex == 0x03 then return "Ken"
    elseif hex == 0x04 then return "Lei-Lei"
    elseif hex == 0x05 then return "Donovan"
    elseif hex == 0x06 then return "Felicia"
    elseif hex == 0x07 then return "Sakura"
    elseif hex == 0x08 then return "Devilot"
    elseif hex == 0x09 then return "Akuma"
    elseif hex == 0x0A then return "Dan"
    else return "None"
    end
end
function print_training_info()
    print("Starting SPF2T Training Script!")
    print("Hotkeys (Set in fbneo input --> Lua Hotkeys):")
    print("1: Send queue'd Gems to both players")
    print("2: Free Diamond")
    print("3: Change p1 pattern/char")
    print("4: Change p2 pattern/char")
	print("5: Add Gems to Drop on P2")
	print("6: Add Gems to Drop on P1")
	print("7: Minus Gems to Drop on P2")
	print("8: Minus Gems to Drop on P1")
	
end

local function get_character_hex_from_name( name )
    if     name == "Morrigan" then return  0x00
    elseif name == "Chun-Li"  then return  0x01
    elseif name == "Ryu"      then return  0x02
    elseif name == "Ken"      then return  0x03
    elseif name == "Lei-Lei"  then return  0x04
    elseif name == "Donovan"  then return  0x05
    elseif name == "Felicia"  then return  0x06
    elseif name == "Sakura"   then return  0x07
    elseif name == "Devilot"  then return  0x08
    elseif name == "Akuma"    then return  0x09
    elseif name == "Dan"      then return  0x0A
    end
end

-- This is how you do exports, to keep your code neat.
utilitiesModule = {
    ["get_character_hex_from_name"] = get_character_hex_from_name,
	["print_training_info"] = print_training_info,
    ["get_character_name_from_hex"] = get_character_name_from_hex,
}
return utilitiesModule