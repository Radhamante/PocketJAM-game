extends Control

signal main_menu_pressed

var music_bus_index: int
var ui_bus_index: int
var sfx_bus_index: int
var master_bus_index: int

@onready var music_volume_slider: HSlider = $VBoxContainer/VBoxContainer/music_volume_slider
@onready var sfx_volume_slider: HSlider = $VBoxContainer/VBoxContainer2/sfx_volume_slider
@onready var ui_volume_slider: HSlider = $VBoxContainer/VBoxContainer3/ui_volume_slider
@onready var master_volume_slider: HSlider = $VBoxContainer/VBoxContainer4/master_volume_slider

func _ready():
	music_bus_index = AudioServer.get_bus_index("Music")
	master_bus_index = AudioServer.get_bus_index("Master")
	ui_bus_index = AudioServer.get_bus_index("UI")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	
	music_volume_slider.value = db_to_linear(AudioServer.get_bus_index("Music"))
	master_volume_slider.value = db_to_linear(AudioServer.get_bus_index("Master"))
	sfx_volume_slider.value = db_to_linear(AudioServer.get_bus_index("SFX"))
	ui_volume_slider.value = db_to_linear(AudioServer.get_bus_index("UI"))


func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))

func _on_ui_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(ui_bus_index, linear_to_db(value))

func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))



func _on_main_menu_pressed() -> void:
	main_menu_pressed.emit()
