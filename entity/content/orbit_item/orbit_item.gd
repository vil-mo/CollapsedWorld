extends Entity
class_name OrbitItem

@export var position_lerping := 0.6
@export var rotation_lerping := 0.6
@export var position_in_local_coords := true

var position_without_using := Vector2.ZERO
var direction := 0.0
var currently_used := false
var using_timer = Timer.new()

@export var positioning_type : OrbitItemPosititoningType
@export var using_type : OrbitItemUsingType

const LOOKING_DIRECTION_META = "looking_direction"

func _ready() -> void:
	add_child(use_timer)
	use_timer.one_shot = true
	
	if emitter.has_meta(LOOKING_DIRECTION_META):
		direction = emitter.get_meta(LOOKING_DIRECTION_META)
	
	var positioning_values = positioning_type.get_positioning_values(self)
	global_position = emitter.global_position + Vector2(positioning_values.x, positioning_values.y)
	rotation = positioning_values.z
	
	if position_in_local_coords:
		position_without_using = Vector2.ZERO
	else:
		position_without_using = global_position

func _physics_process(delta: float) -> void:
	# Positioning 
	if emitter.has_meta(LOOKING_DIRECTION_META):
		direction = emitter.get_meta(LOOKING_DIRECTION_META)
	
	var positioning_values = positioning_type.get_positioning_values(self)
	var target_position
	
	if position_in_local_coords:
		target_position = Vector2(positioning_values.x, positioning_values.y)
	else:
		target_position = emitter.global_position + Vector2(positioning_values.x, positioning_values.y)
	
	var target_rotation = positioning_values.z
	
	position_without_using = lerp(origin, target_position, position_lerping)
	if rotation - target_rotation > PI:
		rotation -= TAU
	elif rotation - target_rotation < -PI:
		rotation += TAU
	rotation = lerp(rotation, target_rotation, rotation_lerping)
	if position_in_local_coords:
		position = position_without_using
	else:
		global_position = position_without_using
	
	# Using
	if !use_timer.is_stopped():
		var current_relative_time = (use_timer.wait_time - use_timer.time_left) / use_timer.wait_time
		var using_values = using_type.get_using_values(current_relative_time, self)
		global_position += Vector2(using_values.x, using_values.y)
		rotation = using_values.z

func use(using_type : OrbitItemUsingType):
	
	use_timer.start(use_durantion)


func spear_positioning() -> Vector3:
	var to_position = distantce_from_entity * Vector2.from_angle(direction)
	var to_rotation = direction
	return Vector3(to_position.x, to_position.y, to_rotation)
func spear_using(time : float) -> Vector3:
	var value = using_curve.sample(time)
	var to_position = Vector2.from_angle(direction) * (spear_using_lenght * value)
	var to_rotation = rotation
	return Vector3(to_position.x, to_position.y, to_rotation)

