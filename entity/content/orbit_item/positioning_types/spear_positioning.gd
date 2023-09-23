extends OrbitItemPosititoningType
class_name SpearPositioning

@export var distantce_from_entity := 6.0

func get_positioning_values(item : OrbitItem):
	
	target_transform.origin = distantce_from_entity * Vector2.from_angle(item.direction)
	target_transform.rotated(-target_transform.get_rotation() + item.direction)
