extends CharacterBody3D
class_name Follower
@export var followers_models: Array[PackedScene]

@export var speed := 8.0
@export var response_speed := 10.0
@export var neighbor_distance := 5.0
@export var separation_distance := 3.0
@export var min_target_distance := 2.0
var	animationPlayer
@export var weight_cohesion := 1.0
@export var weight_separation := 1.0
@export var weight_alignment := 1.0
@export var weight_target := 2.0

@export var grab_range := 5.0
@onready var grab_area: Area3D = $"grab-area"
@onready var kill_particles: CPUParticles3D = $kill_particules
@onready var mesh: MeshInstance3D = $MeshInstance3D
var nav_region : NavigationRegion3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player: Node3D = null
var swarm_root: Node3D
var hold_distance := 0.0
var vertical_velocity := 0.0
var car_position: Vector3
var stay := false

func _ready():
	var rand_pick = followers_models[randf_range(0,3)]
	var picked = rand_pick.instantiate()
	add_child(picked)
	animationPlayer = picked.get_node("AnimationPlayer")
	swarm_root = get_parent_node_3d()
	hold_distance = randf_range(2.0, 4.0)
	grab_area.get_node("CollisionShape3D").shape.radius = grab_range

func _physics_process(delta):
	handle_animation(delta)
	if not player or not swarm_root or not nav_region:
		return
		
	var target_position = car_position if car_position else player.global_position

	var cohesion = Vector3.ZERO
	var separation = Vector3.ZERO
	var alignment = Vector3.ZERO
	var neighbors := 0

	for other in swarm_root.get_children():
		if other == self or not other is Follower:
			continue
		var offset = other.global_position - global_position
		var dist = offset.length()
		if dist < neighbor_distance:
			cohesion += other.global_position
			alignment += other.velocity.normalized()
			if dist < separation_distance:
				separation -= offset.normalized() / dist
			neighbors += 1

	if neighbors > 0:
		cohesion = ((cohesion / neighbors) - global_position).normalized()
		alignment = (alignment / neighbors).normalized()

	var direction = Vector3.ZERO
	var distance_to_target = global_position.distance_to(target_position)
	
	var distance_to_car = global_position.distance_to(car_position)
	var distance_to_player = global_position.distance_to(player.global_position)
	
	var nav_map = nav_region.get_navigation_map()
	
	if distance_to_target > hold_distance:
		var path = NavigationServer3D.map_get_path(nav_map, global_position, target_position, false)
		var target_point = path[1] if path.size() > 1 else target_position
		var to_target = (target_point - global_position).normalized()
		direction = (cohesion * weight_cohesion + separation * weight_separation +
					 alignment * weight_alignment + to_target * weight_target).normalized()
	
	if distance_to_car < min_target_distance:
		var avoid = (global_position - player.global_position).normalized()
		direction = (cohesion * weight_cohesion + separation * weight_separation +
					 alignment * weight_alignment + avoid * weight_target).normalized()
	
	if distance_to_player < min_target_distance:
		var avoid = (global_position - player.global_position).normalized()
		direction = (cohesion * weight_cohesion + separation * weight_separation +
					 alignment * weight_alignment + avoid * weight_target).normalized()
					

	if not is_on_floor():
		vertical_velocity -= gravity * delta
	else:
		vertical_velocity = 0.0

	var target_velocity = direction * speed
	velocity.x = lerp(velocity.x, target_velocity.x, delta * response_speed)
	velocity.z = lerp(velocity.z, target_velocity.z, delta * response_speed)
	velocity.y = vertical_velocity
	move_and_slide()

	if target_position:
		look_at(target_position)
	else:
		look_at(player.position)
	rotation.x = 0
	rotation.z = 0

func kill():
	kill_particles.emitting = true
	mesh.queue_free()
	kill_particles.connect("finished", queue_free)


func _on_grab_area_body_entered(body: Node3D) -> void:
	if body is Player: # Ou vérifie une classe spécifique
		player = body
		grab_area.queue_free()

func set_target_position(pos: Vector3):
	car_position = pos
	
	
func handle_animation(delta):
	var horizontal_velocity = Vector2(velocity.x, velocity.z).length()
	
	if horizontal_velocity > 3.5:
		if animationPlayer.current_animation != "run":
			animationPlayer.play("run", 0.1)
	elif horizontal_velocity > 0.1:
		if animationPlayer.current_animation != "walk":
			animationPlayer.play("walk", 0.1)
	elif animationPlayer.current_animation != "idle":
		animationPlayer.play("idle", 0.1)
