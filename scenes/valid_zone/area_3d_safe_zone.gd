extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is Follower:
		body.set_target_position(global_position)

func _on_body_exited(body: Node3D) -> void:
	if body is Follower:
			body.clear_target_position()
