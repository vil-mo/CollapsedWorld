extends Camera2D

var camera_speed = 0.2
var default_zoom = 2.0
var camera_moving_sensitivity := 10

var target_point := Vector2.ZERO
var target_zoom := 1.0
var is_following := false
var followed_node : Node2D = null
var is_allowed_to_move_camera_width_mouse := false

func follow_node(val : bool, node_to_follow : Node2D = null, allowed_to_move_camera_width_mouse : bool = false):
	is_following = val
	followed_node = node_to_follow
	is_allowed_to_move_camera_width_mouse = allowed_to_move_camera_width_mouse

func _physics_process(delta):
	if is_following:
		if weakref(followed_node).get_ref():
			target_point = followed_node.global_position
			target_zoom = default_zoom
	else:
		target_point = Vector2.ZERO
		target_zoom = 1.0
	
	
	if is_allowed_to_move_camera_width_mouse:
		target_point += (get_global_mouse_position() - global_position) / camera_moving_sensitivity
	
	global_position = lerp(global_position, target_point, camera_speed)
	zoom = Vector2.ONE * lerp(zoom.x, target_zoom, camera_speed)
