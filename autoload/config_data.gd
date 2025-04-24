extends Node

const config_file_path = "user://user_config.cfg"

var temp_config_data: Dictionary = {}
var config_data: Dictionary = {}
var default_config_data: Dictionary = {
	"game": {
		"max_fps": 60,
	},
	"audio": {
		"master_volume": 0.5,
		"music_volume": 0.5,
		"sfx_volume": 0.5,
	},
	"video": {
		"brightness": 1.0,
		"contrast": 1.0,
		"color_blindness": "NORMAL_VISION",
		"color_blindness_intensity": 1.0,
	},
	"language": {
		"text_language": "en",
		"voice_language": "en",
	}
}


func _ready():
	load_config_file()
	apply_settings()


func create_temp_config_file():
	temp_config_data = config_data.duplicate(true)


func load_config_file():
	var config = ConfigFile.new()
	var error = config.load(config_file_path)
	if error != OK:
		print("Failed to load config file. Using defaults.")
		config_data = default_config_data.duplicate(true)
		return
	
	config_data = default_config_data.duplicate(true)  # Start with defaults
	for category in default_config_data.keys():
		if config.has_section(category):
			for key in default_config_data[category].keys():
				if config.has_section_key(category, key):
					config_data[category][key] = config.get_value(category, key, default_config_data[category][key])


func save_config_file():
	var config = ConfigFile.new()
	for category in config_data.keys():
		for key in config_data[category].keys():
			config.set_value(category, key, config_data[category][key])
	
	var error = config.save(config_file_path)
	if error != OK:
		print("Failed to save config file!")
	else:
		print("Config saved!")


func merge_defaults(original: Dictionary, defaults: Dictionary) -> Dictionary:
	for key in defaults.keys():
		if not original.has(key):
			original[key] = defaults[key]
		elif typeof(defaults[key]) == TYPE_DICTIONARY and typeof(original[key]) == TYPE_DICTIONARY:
			original[key] = merge_defaults(original[key], defaults[key])
	return original


func reset_to_defaults(category: String):
	if category in default_config_data:
		config_data[category] = default_config_data[category].duplicate(true)
		save_config_file()


func apply_settings():
	set_volume_percent("Master", config_data["audio"]["master_volume"])
	set_volume_percent("Music", config_data["audio"]["music_volume"])
	set_volume_percent("SFX", config_data["audio"]["sfx_volume"])


func set_volume_percent(bus_name: String, percent: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
