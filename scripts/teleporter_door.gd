extends Area2D
@export var exit_door : Area2D
var exit_position = null
var exit_door_animated_sprite : AnimatedSprite2D = null
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var player_node : CharacterBody2D = null


# Assign position after loaded and disable process
func _ready() -> void:
	set_process(false)
	exit_position = exit_door.get_node("Marker2D").global_position
	exit_door_animated_sprite = exit_door.get_node("AnimatedSprite2D")

func _process(delta: float) -> void:
	if player_node.is_teleport_cooldown_active == false and Input.is_action_just_pressed("interact") == true:
		teleport_player()

# Enable processing when player enters
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") == true:
		player_node = body
		set_process(true)

# Disable processing when player exits
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") == true:
		set_process(false)

# Animate open on entry door, opened on exit door and wait for animation finish
func animate_entry() -> void:
	animated_sprite.play("open")
	exit_door_animated_sprite.play("opened")

# Wait for camera to center, then animate close on exit door and closed on entry door
func animate_exit() -> void:
	await get_tree().create_timer(0.1).timeout
	exit_door_animated_sprite.play("close")
	animated_sprite.play("closed")
	
# Trigger animate functions and change player position to exit door position
func teleport_player() -> void:
	animate_entry()
	await animated_sprite.animation_finished
	player_node.global_position = exit_position
	player_node.trigger_teleport_cooldown(exit_door_animated_sprite)
	animate_exit()
	
