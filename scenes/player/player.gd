extends CharacterBody3D

class_name Player

@export_subgroup("Properties")
@export var movement_speed = 300
@export var max_fall_speed := -15.0
@export var animationPlayer: AnimationPlayer

var movement_velocity: Vector3
var rotation_direction: float
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var grab_range := 5.0
@onready var grab_area: Area3D = $"grab-area"

func _ready() -> void:
	grab_area.get_node("CollisionShape3D").shape.radius = grab_range

# Functions
func _physics_process(delta):

	# Handle functions
	handle_controls(delta)
	handle_effects(delta)
	

	# Movement
	var horizontal_velocity = Vector3(movement_velocity.x, 0, movement_velocity.z)
	var applied_velocity = velocity

	# Interpolation uniquement sur l'horizontale
	applied_velocity.x = lerp(velocity.x, horizontal_velocity.x, delta * 10)
	applied_velocity.z = lerp(velocity.z, horizontal_velocity.z, delta * 10)

	# Soft gravity cap
	var t = inverse_lerp(0.0, max_fall_speed, applied_velocity.y)
	var fall_factor = 1.0 - clamp(t, 0.0, 1.0)
	var soft_gravity = gravity * fall_factor
	applied_velocity.y -= soft_gravity * delta

	# Clamp final fall speed
	applied_velocity.y = max(applied_velocity.y, max_fall_speed)

	velocity = applied_velocity
	move_and_slide()

	# Rotation
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()

	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)



# Handle animation(s)
func handle_effects(delta):

	#sound_footsteps.stream_paused = true

	var horizontal_velocity = Vector2(velocity.x, velocity.z).length()
	
	if horizontal_velocity > 3.5:
		if animationPlayer.current_animation != "run":
			animationPlayer.play("run", 0.1)
	elif horizontal_velocity > 0.1:
		if animationPlayer.current_animation != "walk":
			animationPlayer.play("walk", 0.1)
	elif animationPlayer.current_animation != "idle":
		animationPlayer.play("idle", 0.1)

# Handle movement input

func handle_controls(delta):

	# Movement

	var input := Vector3.ZERO

	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")


	if input.length() > 1:
		input = input.normalized()

	movement_velocity = input * movement_speed * delta
