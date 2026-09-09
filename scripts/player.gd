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


func trigger_teleport_cooldown() -> void:
	is_teleport_cooldown_active = true
	await get_tree().create_timer(0.3).timeout
	is_teleport_cooldown_active = false
	
