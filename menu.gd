extends Control
## Main menu. Sliders (1-10) set the Master, Music and SFX audio bus volumes,
## saved to user://settings.cfg.

const SETTINGS_PATH := "user://settings.cfg"

@onready var main_buttons: Control = $Center/MainButtons
@onready var settings: Control = $Center/Settings
@onready var sliders := {
	"Master": $Center/Settings/Master/Slider,
	"Music": $Center/Settings/Music/Slider,
	"SFX": $Center/Settings/SFX/Slider,
}

var config := ConfigFile.new()


func _ready() -> void:
	$Center/MainButtons/Play.pressed.connect(func(): get_tree().change_scene_to_file("res://main.tscn"))
	$Center/MainButtons/Settings.pressed.connect(_show_settings.bind(true))
	$Center/Settings/Back.pressed.connect(_show_settings.bind(false))
	config.load(SETTINGS_PATH)  # missing file on first run is fine: defaults below
	for bus_name in sliders:
		var slider: HSlider = sliders[bus_name]
		slider.value_changed.connect(_on_volume_changed.bind(bus_name))
		slider.value = config.get_value("audio", bus_name, 10.0)
		_on_volume_changed(slider.value, bus_name)  # apply even when value didn't change


func _on_volume_changed(value: float, bus_name: String) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value / 10.0))
	config.set_value("audio", bus_name, value)
	config.save(SETTINGS_PATH)  # tiny file; saving every change means closing mid-settings loses nothing


func _show_settings(on: bool) -> void:
	main_buttons.visible = not on
	settings.visible = on
