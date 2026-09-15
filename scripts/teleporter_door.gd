extends Area2D
@export var exit_door : Area2D
@onready var marker_2d: Marker2D = $Marker2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var open_sound: AudioStreamPlayer2D = $Open_sound
@onready var close_sound: AudioStreamPlayer2D = $Close_sound
var player_node : CharacterBody2D = null
var door_cooldown_active : bool = false

# Disable processing after loading
func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	if door_cooldown_active == false and Input.is_action_just_pressed("interact") == true:
		teleport_player()

# Enable processing when player enters and update player node
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") == true:
		player_node = body
		set_process(true)

# Disable processing when player exits
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") == true:
		set_process(false)

#Enable cooldown, trigger sound, animate open on entry door, opened on exit door and wait for animation finish
func enter() -> void:
	door_cooldown_active = true
	exit_door.door_cooldown_active = true
	animated_sprite.play("open")
	open_sound.play()
	exit_door.animated_sprite.play("opened")

# Wait for camera to center, animate close on exit door, closed on entry door, trigger sound, disable cooldown
func exit() -> void:
	await get_tree().create_timer(0.1).timeout
	exit_door.animated_sprite.play("close")
	#This is the value you get after subtracting close sound length from close animation length
	await get_tree().create_timer(0.215).timeout
	exit_door.close_sound.play()
	await exit_door.animated_sprite.animation_finished
	animated_sprite.play("closed")
	door_cooldown_active = false
	exit_door.door_cooldown_active = false
	
# Trigger animation/sound functions and change player position to exit door position
func teleport_player() -> void:
	enter()
	await animated_sprite.animation_finished
	player_node.global_position = exit_door.marker_2d.global_position
	exit()
	
