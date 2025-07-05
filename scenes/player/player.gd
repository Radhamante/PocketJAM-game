extends CharacterBody3D


@export_subgroup("Properties")
@export var movement_speed = 250
@export var jump_strength = 5
@export var max_fall_speed := -15.0


var movement_velocity: Vector3
var rotation_direction: float
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var particles_trail = $ParticlesTrail
@onready var sound_footsteps = $SoundFootsteps
@onready var model = $Character
@onready var animation = $Character/AnimationPlayer


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

	#particles_trail.emitting = false
	#sound_footsteps.stream_paused = true

	if is_on_floor():
		var horizontal_velocity = Vector2(velocity.x, velocity.z)
		var speed_factor = horizontal_velocity.length() / movement_speed / delta
		#if speed_factor > 0.05:
			#if animation.current_animation != "walk":
				#animation.play("walk", 0.1)
#
			#if speed_factor > 0.3:
				#sound_footsteps.stream_paused = false
				#sound_footsteps.pitch_scale = speed_factor
#
			#if speed_factor > 0.75:
				#particles_trail.emitting = true
#
		#elif animation.current_animation != "idle":
			#animation.play("idle", 0.1)
	#elif animation.current_animation != "jump":
		#animation.play("jump", 0.1)

# Handle movement input

func handle_controls(delta):

	# Movement

	var input := Vector3.ZERO

	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")


	if input.length() > 1:
		input = input.normalized()

	movement_velocity = input * movement_speed * delta
