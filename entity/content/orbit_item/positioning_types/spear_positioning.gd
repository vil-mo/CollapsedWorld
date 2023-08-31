extends OrbitItemPosititoningType
class_name SpearPositioning

func get_positioning_values(item : OrbitItem):
	var to_position = distantce_from_entity * Vector2.from_angle(item.direction)
	var to_rotation = item.direction
	return Vector3(to_position.x, to_position.y, to_rotation)
