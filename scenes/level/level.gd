extends Node3D

signal game_ended(day_time: float, gamer_saved: int)

@export var sun: DirectionalLight3D
@export var day_duration = 10.0


@onready var valid_zone: Node3D = $world/BobbYCar/ValidZone

@onready var progress_bar: ProgressBar = $CanvasLayer/MarginContainer/ProgressBar


@export_range(0.0,365.0) var sun_hue = 16.0
@export_range(0.0,100.0) var sun_max_saturation = 37.0

var gamer_saved = 0
var day_time = 0.0

func _ready() -> void:
	sun_hue = sun_hue/365
	sun_max_saturation = sun_max_saturation/100
	
	progress_bar.max_value = day_duration
	progress_bar.value = 0

func _process(delta: float) -> void:
	day_time += delta
	
	progress_bar.value = day_time
	
	sun.rotation_degrees.x = remap(day_time, 0, day_duration, 30, -270)
	
	var sun_color_saturation = 0
	var third_of_day = day_duration / 3
	
	if day_time < third_of_day:
		sun_color_saturation = remap(day_time, 0, third_of_day, sun_max_saturation, 0)
	elif day_time < (third_of_day)*2:
		sun_color_saturation = remap(day_time, third_of_day, third_of_day*2, 0, sun_max_saturation)
	else:
		sun_color_saturation = remap(day_time, third_of_day, third_of_day*2, 0, sun_max_saturation)
			
	sun.light_color = Color.from_hsv(sun_hue, sun_color_saturation, 1)
	
	if day_time >= day_duration:
		day_time = day_duration
		_day_ended()
	
	
func remap(value: float, old_min: float, old_max: float, new_min: float, new_max: float):
	var normalized_value = (value - old_min) / (old_max - old_min)
	var new_value = new_min + normalized_value * (new_max - new_min)
	return new_value

func _day_ended() -> void:
	gamer_saved = valid_zone.get_gamer_count()
	game_ended.emit(gamer_saved, day_time)
