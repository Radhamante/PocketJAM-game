extends Node3D

signal game_ended(day_time: float, gamer_saved: int)

@export var sun: DirectionalLight3D
@export var day_duration = 3.0


var gamer_saved = 0
var day_time = 0.0

func _process(delta: float) -> void:
	day_time += delta
	sun.rotation_degrees.x = remap(day_time, 0, day_duration, 0, -270)
	
	if day_time >= day_duration:
		day_time = 3.0
		_day_ended()
	
	
func remap(value: float, old_min: float, old_max: float, new_min: float, new_max: float):
	var normalized_value = (value - old_min) / (old_max - old_min)
	var new_value = new_min + normalized_value * (new_max - new_min)
	return new_value

func _day_ended() -> void:
	game_ended.emit(gamer_saved, day_time)
