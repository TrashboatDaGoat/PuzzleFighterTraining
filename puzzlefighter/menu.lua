-- menu
text_default_color = 0x0ACDFFFF
text_default_border_color = 0x101008FF
text_selected_color = 0xFF9FB2FF
text_disabled_color = 0xFFD166FF

function check_input_down_autofire(_player_object, _input, _autofire_rate, _autofire_time)
  _autofire_rate = _autofire_rate or 4
  _autofire_time = _autofire_time or 23
  if _player_object.input.pressed[_input] or (_player_object.input.down[_input] and _player_object.input.state_time[_input] > _autofire_time and (_player_object.input.state_time[_input] % _autofire_rate) == 0) then
    return true
  end
  return false
end

function gauge_menu_item(_name, _object, _property_name, _unit, _fill_color, _gauge_max, _subdivision_count)
  local _o = {}
  _o.name = _name
  _o.object = _object
  _o.property_name = _property_name
  _o.player_id = _player_id
  _o.autofire_rate = 1
  _o.unit = _unit or 2
  _o.gauge_max = _gauge_max or 0
  _o.subdivision_count = _subdivision_count or 1
  _o.fill_color = _fill_color or 0x0000FFFF

  function _o:draw(_x, _y, _selected)
    local _c = text_default_color
    local _prefix = ""
    local _suffix = ""
    if _selected then
      _c = text_selected_color
      _prefix = "< "
      _suffix = " >"
    end
    gui.text(_x, _y, _prefix..self.name.." : ", _c, text_default_border_color)

    local _box_width = self.gauge_max / self.unit
    local _box_top = _y + 1
    local _box_left = _x + get_text_width("< "..self.name.." : ") - 1
    local _box_right = _box_left + _box_width
    local _box_bottom = _box_top + 4
    gui.box(_box_left, _box_top, _box_right, _box_bottom, text_default_color, text_default_border_color)
    local _content_width = self.object[self.property_name] / self.unit
    gui.box(_box_left, _box_top, _box_left + _content_width, _box_bottom, self.fill_color, 0x00000000)
    for _i = 1, self.subdivision_count - 1 do
      local _line_x = _box_left + _i * self.gauge_max / (self.subdivision_count * self.unit)
      gui.line(_line_x, _box_top, _line_x, _box_bottom, text_default_border_color)
    end

    gui.text(_box_right + 2, _y, _suffix, _c, text_default_border_color)
  end

  function _o:left()
    self.object[self.property_name] = math.max(self.object[self.property_name] - self.unit, 0)
  end

  function _o:right()
    self.object[self.property_name] = math.min(self.object[self.property_name] + self.unit, self.gauge_max)
  end

  function _o:reset()
    self.object[self.property_name] = 0
  end

  function _o:legend()
    return "MP: Reset to default"
  end

  return _o
end

available_characters = {
  " ",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "X",
  "Y",
  "Z",
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "-",
  "_",
}

function textfield_menu_item(_name, _object, _property_name, _default_value, _max_length)
  _default_value = _default_value or ""
  _max_length = _max_length or 16
  local _o = {}
  _o.name = _name
  _o.object = _object
  _o.property_name = _property_name
  _o.default_value = _default_value
  _o.max_length = _max_length
  _o.edition_index = 0
  _o.is_in_edition = false
  _o.content = {}

  function _o:sync_to_var()
    local _str = ""
    for i = 1, #self.content do
      _str = _str..available_characters[self.content[i]]
    end
    self.object[self.property_name] = _str
  end

  function _o:sync_from_var()
    self.content = {}
    for i = 1, #self.object[self.property_name] do
      local _c = self.object[self.property_name]:sub(i,i)
      for j = 1, #available_characters do
        if available_characters[j] == _c then
          table.insert(self.content, j)
          break
        end
      end
    end
  end

  function _o:crop_char_table()
    local _last_empty_index = 0
    for i = 1, #self.content do
      if self.content[i] == 1 then
        _last_empty_index = i
      else
        _last_empty_index = 0
      end
    end

    if _last_empty_index > 0 then
      for i = _last_empty_index, #self.content do
        table.remove(self.content, _last_empty_index)
      end
    end
  end

  function _o:draw(_x, _y, _selected)
    local _c = text_default_color
    local _prefix = ""
    local _suffix = ""
    if self.is_in_edition then
      _c =  0xFFFF00FF
    elseif _selected then
      _c = text_selected_color
    end

    local _value = self.object[self.property_name]

    if self.is_in_edition then
      local _cycle = 100
      if ((frame_number % _cycle) / _cycle) < 0.5 then
        gui.text(_x + (#self.name + 3 + #self.content - 1) * 4, _y + 2, "_", _c, text_default_border_color)
      end
    end

    gui.text(_x, _y, _prefix..self.name.." : ".._value.._suffix, _c, text_default_border_color)
  end

  function _o:left()
    if self.is_in_edition then
      self:reset()
    end
  end

  function _o:right()
    if self.is_in_edition then
      self:validate()
    end
  end

  function _o:up()
    if self.is_in_edition then
      self.content[self.edition_index] = self.content[self.edition_index] + 1
      if self.content[self.edition_index] > #available_characters then
        self.content[self.edition_index] = 1
      end
      self:sync_to_var()
      return true
    else
      return false
    end
  end

  function _o:down()
    if self.is_in_edition then
      self.content[self.edition_index] = self.content[self.edition_index] - 1
      if self.content[self.edition_index] == 0 then
        self.content[self.edition_index] = #available_characters
      end
      self:sync_to_var()
      return true
    else
      return false
    end
  end

  function _o:validate()
    if not self.is_in_edition then
      self:sync_from_var()
      if #self.content < self.max_length then
        table.insert(self.content, 1)
      end
      self.edition_index = #self.content
      self.is_in_edition = true
    else
      if self.content[self.edition_index] ~= 1 then
        if #self.content < self.max_length then
          table.insert(self.content, 1)
          self.edition_index = #self.content
        end
      end
    end
    self:sync_to_var()
  end

  function _o:reset()
    if not self.is_in_edition then
      _o.content = {}
      self.edition_index = 0
    else
      if #self.content > 1 then
        table.remove(self.content, #self.content)
        self.edition_index = #self.content
      else
        self.content[1] = 1
      end
    end
    self:sync_to_var()
  end

  function _o:cancel()
    if self.is_in_edition then
      self:crop_char_table()
      self:sync_to_var()
      self.is_in_edition = false
    end
  end

  function _o:legend()
    if self.is_in_edition then
      return "LP/Right: Next   MP/Left: Previous   LK: Leave edition"
    else
      return "LP: Edit   MP: Reset to default"
    end
  end

  _o:sync_from_var()
  return _o
end

function checkbox_menu_item(_name, _object, _property_name, _default_value, description)
  if _default_value == nil then _default_value = false end
  local _o = {}
  _o.name = _name
  _o.object = _object
  _o.property_name = _property_name
  _o.default_value = _default_value

  function _o:draw(_x, _y, _selected)
    local _c = text_default_color
    local _prefix = ""
    local _suffix = ""
    if _selected then
      _c = text_selected_color
      _prefix = "< "
      _suffix = " >"
    end

    local _value = ""
    if self.object[self.property_name] then
      _value = "yes"
    else
      _value = "no"
    end
    gui.text(_x, _y, _prefix..self.name.." : ".._value.._suffix, _c, text_default_border_color)
  end

  function _o:left()
    self.object[self.property_name] = not self.object[self.property_name]
  end

  function _o:right()
    self.object[self.property_name] = not self.object[self.property_name]
  end

  function _o:reset()
    self.object[self.property_name] = self.default_value
  end

  function _o:legend()
    return "MP: Reset to default"
  end
  function _o:description()
    if description then
      return description
    else
      return ""
    end
  end
  return _o
end

function list_menu_item(_name, _object, _property_name, _list, _default_value, _item_description, _default_description )
  if _default_value == nil then _default_value = 1 end
  local _o = {}
  _o.name = _name
  _o.object = _object
  _o.property_name = _property_name
  _o.list = _list
  _o.default_value = _default_value

  function _o:draw(_x, _y, _selected)
    local _c = text_default_color
    local _prefix = ""
    local _suffix = ""
    if _selected then
      _c = text_selected_color
      _prefix = "< "
      _suffix = " >"
    end
    gui.text(_x, _y, _prefix..self.name.." : "..tostring(self.list[self.object[self.property_name]]).._suffix, _c, text_default_border_color)
  end

  function _o:left()
    self.object[self.property_name] = self.object[self.property_name] - 1
    if self.object[self.property_name] == 0 then
      self.object[self.property_name] = #self.list
    end
  end

  function _o:right()
    self.object[self.property_name] = self.object[self.property_name] + 1
    if self.object[self.property_name] > #self.list then
      self.object[self.property_name] = 1
    end
  end

  function _o:reset()
    self.object[self.property_name] = self.default_value
  end

  function _o:legend()
    return "MP: Reset to default"
  end

  function _o:description()
    if type(_item_description) == "table" then
      if _item_description[self.object[self.property_name]] ~= nil then
        return _item_description[self.object[self.property_name]]
      elseif _default_description then
        return _default_description
      else 
        return "" 
      end
    elseif type(_item_description) == "string" then
      return _item_description
    elseif not _item_description and _default_description then
      return _default_description
    else
      return ""
    end
  end
  return _o
end

function integer_menu_item(_name, _object, _property_name, _min, _max, _loop, _default_value, _autofire_rate, description)
  if _default_value == nil then _default_value = _min end
  local _o = {}
  _o.name = _name
  _o.object = _object
  _o.property_name = _property_name
  _o.min = _min
  _o.max = _max
  _o.loop = _loop
  _o.default_value = _default_value
  _o.autofire_rate = _autofire_rate

  function _o:draw(_x, _y, _selected)
    local _c = text_default_color
    local _prefix = ""
    local _suffix = ""
    if _selected then
      _c = text_selected_color
      _prefix = "< "
      _suffix = " >"
    end
    gui.text(_x, _y, _prefix..self.name.." : "..tostring(self.object[self.property_name]).._suffix, _c, text_default_border_color)
  end

  function _o:left()
    self.object[self.property_name] = self.object[self.property_name] - 1
    if self.object[self.property_name] < self.min then
      if self.loop then
        self.object[self.property_name] = self.max
      else
        self.object[self.property_name] = self.min
      end
    end
  end

  function _o:right()
    self.object[self.property_name] = self.object[self.property_name] + 1
    if self.object[self.property_name] > self.max then
      if self.loop then
        self.object[self.property_name] = self.min
      else
        self.object[self.property_name] = self.max
      end
    end
  end

  function _o:reset()
    self.object[self.property_name] = self.default_value
  end

  function _o:legend()
    return "MP: Reset to default"
  end
  function _o:description()
    if description then
      return description
    else
      return ""
    end
  end
  return _o
end

function map_menu_item(_name, _object, _property_name, _map_object, _map_property)
  local _o = {}
  _o.name = _name
  _o.object = _object
  _o.property_name = _property_name
  _o.map_object = _map_object
  _o.map_property = _map_property

  function _o:draw(_x, _y, _selected)
    local _c = text_default_color
    local _prefix = ""
    local _suffix = ""
    if _selected then
      _c = text_selected_color
      _prefix = "< "
      _suffix = " >"
    end

    local _str = string.format("%s%s : %s%s", _prefix, self.name, self.object[self.property_name], _suffix)
    gui.text(_x, _y, _str, _c, text_default_border_color)
  end

  function _o:left()
    if self.map_property == nil or self.map_object == nil or self.map_object[self.map_property] == nil then
      return
    end

    if self.object[self.property_name] == "" then
      for _key, _value in pairs(self.map_object[self.map_property]) do
        self.object[self.property_name] = _key
      end
    else
      local _previous_key = ""
      for _key, _value in pairs(self.map_object[self.map_property]) do
        if _key == self.object[self.property_name] then
          self.object[self.property_name] = _previous_key
          return
        end
        _previous_key = _key
      end
      self.object[self.property_name] = ""
    end
  end

  function _o:right()
    if self.map_property == nil or self.map_object == nil or self.map_object[self.map_property] == nil then
      return
    end

    if self.object[self.property_name] == "" then
      for _key, _value in pairs(self.map_object[self.map_property]) do
        self.object[self.property_name] = _key
        return
      end
    else
      local _previous_key = ""
      for _key, _value in pairs(self.map_object[self.map_property]) do
        if _previous_key == self.object[self.property_name] then
          self.object[self.property_name] = _key
          return
        end
        _previous_key = _key
      end
      self.object[self.property_name] = ""
    end
  end

  function _o:reset()
    self.object[self.property_name] = ""
  end

  function _o:legend()
    return "MP: Reset to default"
  end

  return _o
end

function button_menu_item(_name, _validate_function)
  local _o = {}
  _o.name = _name
  _o.validate_function = _validate_function
  _o.last_frame_validated = 0

  function _o:draw(_x, _y, _selected)
    local _c = text_default_color
    if _selected then
      _c = text_selected_color

      if (frame_number - self.last_frame_validated < 5 ) then
        _c = 0xFFFF00FF
      end
    end

    gui.text(_x, _y,self.name, _c, text_default_border_color)
  end

  function _o:validate()
    self.last_frame_validated = frame_number
    if self.validate_function then
      self.validate_function()
    end
  end

  function _o:legend()
    return "LP: Validate"
  end

  return _o
end

function make_popup(_left, _top, _right, _bottom, _entries)
  local _p = {}
  _p.left = _left
  _p.top = _top
  _p.right = _right
  _p.bottom = _bottom
  _p.entries = _entries

  return _p
end

local p2_character = {
  "Morrigan",
  "Chun_li",
  "Ryu",
  "Ken",
  "Lei-Lei",
  "Donovan",
  "Felicia",
  "Sakura",
  "Devilot",
  "Akuma",
  "Dan",
  "Select Character",
}
local p1_character = {
  "Morrigan",
  "Chun_li",
  "Ryu",
  "Ken",
  "Lei-Lei",
  "Donovan",
  "Felicia",
  "Sakura",
  "Devilot",
  "Akuma",
  "Dan",
  "Select Character",
}
local function get_menu() 
return {
    {
        name = "Menu",
        entries = {
          --                    Name            Settings      Default    Key on Training Mode Json Object         Description
          checkbox_menu_item("Infinite Time", training_settings, "infinite_time",true, "Setting this will cause the timer to not \ndecrement on the Character Select Screen"),
          -- Parameters: _name, _object, _property_name, _list, _default_value, _item_description, _default_description
           list_menu_item("P1 Character", training_settings, "p1_character", p1_character,12,"Change the garbage pattern used by P1"),
		    list_menu_item("P2 Character", training_settings, "p2_character", p2_character,12,"Change the garbage pattern used by P2"),
          -- Parameters: _name, _object, _property_name, _min, _max, _loop, _default_value, _autofire_rate, description
          integer_menu_item("Margin Time", training_settings, "margin_time", 1, 13, true, 1, nil, "Simulate different levels of Margin Time"),
          checkbox_menu_item("Fix Margin Time", training_settings, "margin_fix",true, "If true: Margin time will stay at set level. \n Otherwise: Set the margin time, and progress normally afterwards"),
          checkbox_menu_item("Show Display", training_settings, "show_display",true, "Show the On Screen Display"),
		    checkbox_menu_item("No Diamond", training_settings, "no_diamond",false, "Turn Off Diamonds"),

        }
      },
    --   {
    --     name = "Menu 2",
    --     entries = {
    --       integer_menu_item("P1 Max Life", training_settings, "p1_max_life", 0, 288, false, 288, nil, "The max life, 288 is two bats"),
    --     }
    --   },
    -- {
    --     name = "Menu 3",
    --     entries = {
    --       list_menu_item("Pose", training_settings, "dummy_neutral", dummy_neutral,1,"The dummy will hold this direction."),
    --     }
    -- },
    -- {
    --   name = "Menu 4",
    --   entries = {
    --     checkbox_menu_item("HUD", training_settings, "display_hud", "Shows Health and Meter values"),
    --   }
    -- },
    -- {
    --   name = "Menu 5",
    --   entries = {
    --     checkbox_menu_item("Show Invuln Timer", training_settings, "show_invuln_timer", false,""),
    --   }
    -- }
}
end


main_menu_selected_index = 1
is_main_menu_selected = true
sub_menu_selected_index = 1
current_popup = nil
function piecePause()
    memory.writebyte(0xFF8315, 0x02)
   end

function togglemenu()
if globals.state.in_match == false then
	return
end
	globals.show_menu =  not globals.show_menu
	 
end
local is_main_menu_selected = true
menuModule = {
	["piecePause"] = piecePause,
    ["registerStart"] = function()
      return{
        togglemenu = togglemenu,
      }
    end,
    ["guiRegister"] = function()
      
      menu = get_menu()
      
        -- globals.show_menu = true
        if globals.show_menu then
          local _current_entry = menu[main_menu_selected_index].entries[sub_menu_selected_index]
      
          if current_popup then
            _current_entry = current_popup.entries[current_popup.selected_index]
          end
          local _horizontal_autofire_rate = 4
          local _vertical_autofire_rate = 4
          if not is_main_menu_selected then
            if _current_entry.autofire_rate then
              _horizontal_autofire_rate = _current_entry.autofire_rate
            end
          end
      
          function _sub_menu_down()
            sub_menu_selected_index = sub_menu_selected_index + 1
            _current_entry = menu[main_menu_selected_index].entries[sub_menu_selected_index]
            if sub_menu_selected_index > #menu[main_menu_selected_index].entries then
              is_main_menu_selected = true
            elseif _current_entry.is_disabled ~= nil and _current_entry.is_disabled() then
              _sub_menu_down()
            end
          end
      
          function _sub_menu_up()
            sub_menu_selected_index = sub_menu_selected_index - 1
            _current_entry = menu[main_menu_selected_index].entries[sub_menu_selected_index]
            if sub_menu_selected_index == 0 then
              is_main_menu_selected = true
            elseif _current_entry.is_disabled ~= nil and _current_entry.is_disabled() then
              _sub_menu_up()
            end
          end
      
          if check_input_down_autofire(player_objects[1], "down", _vertical_autofire_rate) or check_input_down_autofire(player_objects[2], "down", _vertical_autofire_rate) then
            if is_main_menu_selected then
              is_main_menu_selected = false
              sub_menu_selected_index = 0
              _sub_menu_down()
            elseif _current_entry.down and _current_entry:down() then
              save_training_data()
            elseif current_popup then
              current_popup.selected_index = current_popup.selected_index + 1
              if current_popup.selected_index > #current_popup.entries then
                current_popup.selected_index = 1
              end
            else
              _sub_menu_down()
            end
          end
      
          if check_input_down_autofire(player_objects[1], "up", _vertical_autofire_rate) or check_input_down_autofire(player_objects[2], "up", _vertical_autofire_rate) then
            if is_main_menu_selected then
              is_main_menu_selected = false
              sub_menu_selected_index = #menu[main_menu_selected_index].entries + 1
              _sub_menu_up()
            elseif _current_entry.up and _current_entry:up() then
                save_training_data()
            elseif current_popup then
              current_popup.selected_index = current_popup.selected_index - 1
              if current_popup.selected_index == 0 then
                current_popup.selected_index = #current_popup.entries
              end
            else
              _sub_menu_up()
            end
          end
      
          if check_input_down_autofire(player_objects[1], "left", _horizontal_autofire_rate) or check_input_down_autofire(player_objects[2], "left", _horizontal_autofire_rate) then
            if is_main_menu_selected then
              main_menu_selected_index = main_menu_selected_index - 1
              if main_menu_selected_index == 0 then
                main_menu_selected_index = #menu
              end
            elseif _current_entry.left then
              _current_entry:left()
              save_training_data()
            end
          end
      
          if check_input_down_autofire(player_objects[1], "right", _horizontal_autofire_rate) or check_input_down_autofire(player_objects[2], "right", _horizontal_autofire_rate) then
            if is_main_menu_selected then
              main_menu_selected_index = main_menu_selected_index + 1
              if main_menu_selected_index > #menu then
                main_menu_selected_index = 1
              end
            elseif _current_entry.right then
              _current_entry:right()
              save_training_data()
            end
          end
      
          if P1.input.pressed.LP or P2.input.pressed.LP then
            if is_main_menu_selected then
            elseif _current_entry.validate then
              _current_entry:validate()
              save_training_data()
            end
          end
      
          if P1.input.pressed.MP or P2.input.pressed.MP then
            if is_main_menu_selected then
            elseif _current_entry.reset then
              _current_entry:reset()
              save_training_data()
            end
          end
      
          if P1.input.pressed.LK or P2.input.pressed.LK then
            if is_main_menu_selected then
            elseif _current_entry.cancel then
              _current_entry:cancel()
              save_training_data()
            end
          end
      
          -- screen size 383,223
          local _gui_box_bg_color = 0x60AB9AFF
          local _gui_box_outline_color = 0x565656FF
          local _menu_box_left = 23
          local _menu_box_top = 15
          local _menu_box_right = 360
          local _menu_box_bottom = 195
          gui.box(_menu_box_left, _menu_box_top, _menu_box_right, _menu_box_bottom, _gui_box_bg_color, _gui_box_outline_color)
      
          local _bar_x = _menu_box_left + 10
          local _bar_y = _menu_box_top + 6
          local _base_offset = 0
          for i = 1, #menu do
            local _offset = 0
            local _c = text_disabled_color
            local _t = menu[i].name
            if is_main_menu_selected and i == main_menu_selected_index then
              _t = "< ".._t.." >"
              _c = text_selected_color
            elseif i == main_menu_selected_index then
              _c = text_default_color
              _offset = 8
            else
              _offset = 8
            end
            gui.text(_bar_x + _offset + _base_offset, _bar_y, _t, _c, text_default_border_color)
            _base_offset = _base_offset + (#menu[i].name + 5) * 4
          end
      
      
          local _menu_x = _menu_box_left + 10
          local _menu_y = _menu_box_top + 23
          local _menu_y_interval = 10
          local _draw_index = 0
          for i = 1, #menu[main_menu_selected_index].entries do
            if menu[main_menu_selected_index].entries[i].is_disabled == nil or not menu[main_menu_selected_index].entries[i].is_disabled() then
              menu[main_menu_selected_index].entries[i]:draw(_menu_x, _menu_y + _menu_y_interval * _draw_index, not is_main_menu_selected and not current_popup and sub_menu_selected_index == i)
              _draw_index = _draw_index + 1
            end
          end
      
          -- recording slots special display
          -- if main_menu_selected_index == 3 then
          --   local _t = string.format("%d frames", #recording_slots[training_settings.current_recording_slot].inputs)
          --   gui.text(_menu_box_left + 83, _menu_y + 2 * _menu_y_interval, _t, text_disabled_color, text_default_border_color)
          -- end
      
          if not is_main_menu_selected then
            if menu[main_menu_selected_index].entries[sub_menu_selected_index].legend then
              gui.text(_menu_x, _menu_box_bottom - 12, menu[main_menu_selected_index].entries[sub_menu_selected_index]:legend(), text_disabled_color, text_default_border_color)
            end
            if menu[main_menu_selected_index].entries[sub_menu_selected_index].description then
              local description = menu[main_menu_selected_index].entries[sub_menu_selected_index]:description()
              gui.text(_menu_x, _menu_box_bottom - 45, description, text_disabled_color, text_default_border_color)
            end
          end
      
          -- popup
          if current_popup then
            gui.box(current_popup.left, current_popup.top, current_popup.right, current_popup.bottom, _gui_box_bg_color, _gui_box_outline_color)
      
            _menu_x = current_popup.left + 10
            _menu_y = current_popup.top + 9
            _draw_index = 0
      
            for i = 1, #current_popup.entries do
              if current_popup.entries[i].is_disabled == nil or not current_popup.entries[i].is_disabled() then
                current_popup.entries[i]:draw(_menu_x, _menu_y + _menu_y_interval * _draw_index, current_popup.selected_index == i)
                _draw_index = _draw_index + 1
              end
            end
      
            if current_popup.entries[current_popup.selected_index].legend then
              gui.text(_menu_x, current_popup.bottom - 12, current_popup.entries[current_popup.selected_index]:legend(), text_disabled_color, text_default_border_color)
            end
          end
      
        else
          gui.box(0,0,0,0,0,0) -- if we don't draw something, what we drawed from last frame won't be cleared
        end
    end
}

return menuModule
