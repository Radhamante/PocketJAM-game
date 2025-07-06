extends AudioStreamPlayer

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)

func _play():
	playing = true

func _on_node_added(node:Node) -> void:
	if node is Button:
		node.connect("pressed", _play)
