local json              = require './puzzlefighter/dkjson'

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
local function print_training_info()
    print("Starting SPF2T Training Script!")
    print("Hotkeys (Set in fbneo input --> Lua Hotkeys):")
    print("1: Send queue'd Gems to both players")
    print("2: Free Diamond")
    print("3: Add Gems to Drop on P2")
    print("4: Add Gems to Drop on P1")
    print("5: Minus Gems to Drop on P2")
    print("6: Minus Gems to Drop on P1")
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

local debounceStarted = nil
local function debounce(func, debounceTime)
    if debounceStarted == nil then 
      debounceStarted = globals.current_frame
      func()
      return
    end
    if debounceStarted + debounceTime <  globals.current_frame then
      debounceStarted = globals.current_frame
      func()
      return
    end
end

function read_object_from_json_file(_file_path)
	local _f = io.open(_file_path, "r")
	if _f == nil then
	  return nil
	end
  
	local _object
	local _pos, _err
	_object, _pos, _err = json.decode(_f:read("*all"))
	_f:close()
  
	if (err) then
	  print(string.format("Failed to find json file \"%s\" : %s", _file_path, _err))
	end
  
	return _object
end
  
function write_object_to_json_file(_object, _file_path)
	local _f = io.open(_file_path, "w")
	if _f == nil then
	  return false
	end
  
	local _str = json.encode(_object, { indent = true })
	_f:write(_str)
	_f:close()
  
	return true
end

function save_training_data()
	-- backup_recordings()
	if not write_object_to_json_file(training_settings, training_settings_file) then
		print(string.format("Error: Failed to save training settings to \"%s\"", training_settings_file))
	end
end
function load_training_data()
	local _training_settings = read_object_from_json_file(training_settings_file)
	if _training_settings == nil then
		_training_settings = {}
	end
	for _key, _value in pairs(_training_settings) do
		training_settings[_key] = _value
	end
end

local last_inputs = nil
local function handle_hotkeys() -- (For hotkeying when it aint a hotkey)
  local _inputs = joypad.getup()
  local down = player_objects[1].input.down
  if last_inputs ~= nil then
        if down["start"] == true then 
            debounce(globals.menuModule.togglemenu,20)
        end
    end
    last_inputs = _inputs
    return _inputs  
end


-- This is how you do exports, to keep your code neat.
utilitiesModule = {
    ["handle_hotkeys"]              = handle_hotkeys,
    ["read_object_from_json_file"]  = read_object_from_json_file,
	["write_object_to_json_file"]   = write_object_to_json_file,
    ["save_training_data"]          = save_training_data,
    ["load_training_data"]          = load_training_data,
    ["get_character_hex_from_name"] = get_character_hex_from_name,
	["print_training_info"]         = print_training_info,
    ["get_character_name_from_hex"] = get_character_name_from_hex,
    ["debounce"]                    = debounce,
}
return utilitiesModule
