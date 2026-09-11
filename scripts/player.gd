extends CharacterBody2D

const SPEED = 300.0
var is_teleport_cooldown_active : bool = false

func _physics_process(delta: float) -> void:

	# Get the input directions and handle the movement.
	var horizontal_direction : float = Input.get_axis("move_left", "move_right")
	var vertical_direction : float = Input.get_axis("move_up", "move_down")
	
	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = 0
		
	if vertical_direction:
		velocity.y = vertical_direction * SPEED
	else:
		velocity.y = 0

	move_and_slide()

# Await exit door animation to finish, then allow teleporting
func trigger_teleport_cooldown(exit_door_animated_sprite: AnimatedSprite2D) -> void:
	is_teleport_cooldown_active = true
	await exit_door_animated_sprite.animation_finished
	is_teleport_cooldown_active = false
	
