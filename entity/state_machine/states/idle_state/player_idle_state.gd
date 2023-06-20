extends DefaultIdleState
class_name PlayerIdleState

var animation_tree_idle_playback : AnimationNodeStateMachinePlayback

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
	animation_tree_idle_playback = entity.get_node("Visuals/AnimationTree").get("parameters/Idle/playback")

func physics_process_state(delta : float):
	super(delta)
	
	
	if Input.is_action_just_pressed("armor"):
		entity.equipment_mahcine.use_action("armor")
	if Input.is_action_just_pressed("weapon1"):
		entity.equipment_mahcine.use_action("weapon1")
	if Input.is_action_just_pressed("weapon2"):
		entity.equipment_mahcine.use_action("weapon2")
	if Input.is_action_just_pressed("accessory1"):
		entity.equipment_mahcine.use_action("accessory1")
	if Input.is_action_just_pressed("accessory2"):
		entity.equipment_mahcine.use_action("accessory2")
	if Input.is_action_just_pressed("accessory3"):
		entity.equipment_mahcine.use_action("accessory3")
	
	
	
	
	movement_direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	
	var closest_direction := Vector2.ZERO
	var closest_distance : float = INF
	var direction_to_mouse = entity.global_position.direction_to(get_global_mouse_position())
	for possible_dir in look_directions:
		var dist = direction_to_mouse.distance_squared_to(possible_dir)
		if dist < closest_distance:
			closest_direction = possible_dir
			closest_distance = dist
	
	animation_tree_idle_playback.travel("Idle" + look_directions[closest_direction])

