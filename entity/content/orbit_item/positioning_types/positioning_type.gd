extends Resource
class_name OrbitItemPosititoningType

@export var distantce_from_entity := 6.0

func get_positioning_values(item : OrbitItem):
	var to_position = item.global_position - item.emitter.global_position
	var to_rotation = item.rotation
	return Vector3(to_position.x, to_position.y, to_rotation)
