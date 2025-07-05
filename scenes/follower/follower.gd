extends CharacterBody3D

class_name Follower

@export var speed := 8.0
@export var response_speed := 6.0
@export var neighbor_distance := 10.0
@export var separation_distance := 3.0
@export var min_player_distance := 2.0

@export var weight_cohesion := 1
@export var weight_separation := 1
@export var weight_alignment := 1
@export var weight_target := 2.0


var hold_player_distance: float
var navigation: NavigationRegion3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player: Node3D
var swarm_root: Node

var vertical_velocity := 0.0

func _ready() -> void:
	swarm_root = get_parent_node_3d()
	hold_player_distance = randf_range(2,7)

func _physics_process(delta):
	if not player or not swarm_root:
		return

	var cohesion = Vector3.ZERO
	var separation = Vector3.ZERO
	var alignment = Vector3.ZERO
	var neighbor_count = 0

	for other in swarm_root.get_children():
		if other == self:
			continue

		var offset = other.global_position - global_position
		var distance = offset.length()
		if distance < neighbor_distance:
			cohesion += other.global_position
			alignment += other.velocity.normalized()
			neighbor_count += 1

			if distance < separation_distance:
				separation -= offset.normalized() / distance

	if neighbor_count > 0:
		cohesion = ((cohesion / neighbor_count) - global_position).normalized()
		alignment = (alignment / neighbor_count).normalized()

	var direction = Vector3.ZERO
	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player > hold_player_distance:
		var nav_map = navigation.get_navigation_map()
		var path = NavigationServer3D.map_get_path(nav_map, global_position, player.global_position, false)

		var target_point = global_position
		if path.size() > 1:
			target_point = path[1]

		var to_player = (target_point - global_position).normalized()
		direction = (
			cohesion * weight_cohesion +
			separation * weight_separation +
			alignment * weight_alignment +
			to_player * weight_target
		).normalized()
	elif distance_to_player < min_player_distance:
		var avoid_player = (global_position - player.global_position).normalized()
		direction = (
			cohesion * weight_cohesion +
			separation * weight_separation +
			alignment * weight_alignment +
			avoid_player * weight_target
		).normalized()
	else:
		direction = Vector3.ZERO

	# Appliquer la gravité
	if not is_on_floor():
		vertical_velocity -= gravity * delta
	else:
		vertical_velocity = 0.0

	# Mouvement horizontal uniquement sur XZ
	var desired_velocity = direction * speed
	velocity.x = lerp(velocity.x, desired_velocity.x, delta * response_speed)
	velocity.z = lerp(velocity.z, desired_velocity.z, delta * response_speed)
	velocity.y = vertical_velocity

	move_and_slide()

	# Rotation uniquement sur Y
	var horizontal_velocity = Vector3(velocity.x, 0, velocity.z)
	if horizontal_velocity.length() > 0.1:
		var look_dir = horizontal_velocity.normalized()
		var target_rotation = Vector3(0, atan2(-look_dir.x, -look_dir.z), 0)
		rotation.y = lerp_angle(rotation.y, target_rotation.y, delta * 5.0)
