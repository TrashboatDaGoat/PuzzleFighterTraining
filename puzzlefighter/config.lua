local default_training_settings = {
    infinite_time = true,
    show_display = true,
    pedagogical_list = 1,
    pedagogical_integer = 0,
    no_diamond = false,
	p2_send_gems = 0,
	p1_send_gems = 0,
    margin_fix = 0
	
  }
  

configModule = {
    ["default_training_settings"] = default_training_settings,
    ["registerBefore"] = function()        
        config_matrix = training_settings
        return config_matrix
    end
}

return configModule
