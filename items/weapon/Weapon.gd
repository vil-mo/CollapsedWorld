extends "res://items/Item.gd"


@export var projectiles := []
@onready var visuals := $Visuals
@onready var animation_player = $Visuals/AnimationPlayer
var is_playing_use_animation := false
const ROTATION_RADIUS = 3
const PLAYER_WIDNESS = Vector2.RIGHT * 4


func _physics_process(delta):
	follow_cursor()

func use():
	if !is_playing_use_animation:
		var next_use_animation = "Use" + str(animation_player.current_animation.to_int() + 1)
		if animation_player.current_animation.begins_with("Use") && animation_player.has_animation(next_use_animation):
			animation_player.play(next_use_animation)
		else:
			animation_player.stop()
			animation_player.play("Use1")
		
		is_playing_use_animation = true


func follow_cursor():
	var mouse_position = get_global_mouse_position()
	
	var k = max(min((mouse_position - global_position).x, 4), -4) / 4
	
	visuals.global_position = global_position + k * PLAYER_WIDNESS + (global_position + k * PLAYER_WIDNESS).direction_to(mouse_position) * ROTATION_RADIUS
	
	visuals.global_rotation = global_position.angle_to_point(mouse_position)
	
	if global_position.direction_to(mouse_position).y > 0:
		visuals.z_index = 1
	else:
		visuals.z_index = -1


func not_playing_use_animation():
	is_playing_use_animation = false
