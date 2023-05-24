extends Node2D

@onready var my_parent = get_parent()

signal drop_player()

func _physics_process(delta):
	global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("use1") || Input.is_action_just_pressed("use2"):
		drop_player.emit()

