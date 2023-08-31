extends Resource
class_name OrbitItemUsingType

@export var use_durantion := 1.0
@export var using_curve : Curve

@export var spear_using_lenght := 10.0

func get_use_values(time : float, item : OrbitItem) -> Vector3:
	var position_difference = item.global_position - item.emitter.global_position
	return Vector3(position_difference.x, position_difference.y, item.rotation)
