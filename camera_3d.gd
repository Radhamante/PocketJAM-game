extends Camera3D

@export var player: CharacterBody3D

func  _process(delta: float) -> void:
	position.z = player.position.z + 29
	
	position.x = player.position.x
