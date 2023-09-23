extends DefaultIdleState
class_name PlayerIdleState


var look_directions : Dictionary = {
	Vector2.RIGHT   : "Right",
	Vector2(1, 1)   : "RightDown",
	Vector2.DOWN    : "Down",
	Vector2(-1, 1)  : "LeftDown",
	Vector2.LEFT    : "Left",
	Vector2(-1, -1) : "LeftUp",
	Vector2.UP      : "Up",
	Vector2(1, -1)  : "RightUp",
}

func ready_state():
	assert(entity is Player, "Why is it not on player?")

func physics_process_state(delta : float):
	super(delta)
	
	movement_direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	
	var direction_to_mouse := (get_global_mouse_position() - entity.global_position).angle()
	entity.directional_animation_player.play_direction("Idle", direction_to_mouse)
	entity.set_meta(OrbitItem.LOOKING_DIRECTION_META, direction_to_mouse)
	
	
	_check_for_used("armor")
	_check_for_used("attack1")
	_check_for_used("attack2")
	_check_for_used("accessory1")
	_check_for_used("accessory2")
	_check_for_used("accessory3")
	

func _check_for_used(action : String):
	if Input.is_action_pressed(action):
		entity.status_mahcine.use_action(action, false)
	if Input.is_action_just_released(action):
		entity.status_mahcine.stop_using_action(action)
