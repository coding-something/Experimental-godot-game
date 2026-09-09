extends Area2D
@export var exit_door : Area2D
var exit_position = null
var player_node : CharacterBody2D = null


# Assign position after loaded and disable process
func _ready() -> void:
	set_process(false)
	exit_position = exit_door.get_node("Marker2D").global_position

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

# Change player position to exit door position
func teleport_player() -> void:
	player_node.global_position = exit_position
	player_node.trigger_teleport_cooldown()
	
