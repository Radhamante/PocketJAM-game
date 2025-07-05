extends Node3D

@export var player: CharacterBody3D
@export var navigation: NavigationRegion3D

func _ready() -> void:
	for child in get_children():
		child.player = player
		child.navigation = navigation
