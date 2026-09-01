extends Area2D
@export var exit_door : Area2D
var exit_position = null

# Assign position after loaded
func _ready() -> void:
	exit_position = exit_door.get_node("Marker2D").global_position

# Teleport player to exit position
func _on_body_entered(body: Node2D) -> void:
	if body.is_teleport_cooldown_active == false:
		body.global_position = exit_position
		body.trigger_teleport_cooldown()
