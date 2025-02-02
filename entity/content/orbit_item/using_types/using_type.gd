extends Resource
class_name OrbitItemUsingType

@export var use_durantion := 1.0

var target_transform : Transform2D = Transform2D()

func use_item(time : float, item : OrbitItem) -> Vector3:
	var position_difference = item.global_position - item.emitter.global_position
	return Vector3(position_difference.x, position_difference.y, item.rotation)
