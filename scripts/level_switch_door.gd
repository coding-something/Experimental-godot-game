extends Area2D
@export var is_exit_door: bool = false
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var open_sound: AudioStreamPlayer2D = $Open_sound
@onready var close_sound: AudioStreamPlayer2D = $Close_sound
var door_triggered: bool = false

# Disable processing after loading, trigger opened animation and closing animation if door is exit
func _ready() -> void:
	set_process(false)
	if is_exit_door == true:
		door_triggered = true
		animated_sprite.play("opened")
		exit()

func _process(_delta: float) -> void:
	if is_exit_door == false and door_triggered == false and Input.is_action_just_pressed("interact") == true:
		switch_level()

# Enable processing when player enters
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") == true:
		set_process(true)

# Disable processing when player exits
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") == true:
		set_process(false)

#Enable cooldown, trigger sound, animate open
func enter() -> void:
	door_triggered = true
	animated_sprite.play("open")
	open_sound.play()

# Animate close on exit door and trigger sound
func exit() -> void:
	await get_tree().create_timer(0.1).timeout
	animated_sprite.play("close")
	#This is the value you get after subtracting close sound length from close animation length
	await get_tree().create_timer(0.215).timeout
	close_sound.play()
	await animated_sprite.animation_finished
	animated_sprite.play("closed")
	
# Trigger enter function and change level to next one
func switch_level() -> void:
	enter()
	await animated_sprite.animation_finished
	var current_level_file = get_tree().current_scene.scene_file_path
	var next_lvl_num = current_level_file.to_int() + 1
	var next_level_file = "res://levels/lvl_" + str(next_lvl_num) + ".tscn"
	get_tree().change_scene_to_file(next_level_file)
	
