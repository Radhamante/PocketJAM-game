extends Camera3D

@export var player: CharacterBody3D

func  _process(delta: float) -> void:
	position.x = player.position.x + 5.0
	position.z = player.position.z + 20.0
