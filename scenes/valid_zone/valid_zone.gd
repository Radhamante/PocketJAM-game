extends Node3D

@onready var area_3d: Area3D = $Area3D

func get_gamer_count() -> int:
	var count = 0
	for body in area_3d.get_overlapping_bodies():
		if body is Follower:
			count += 1
	return count
