extends Resource
class_name OrbitItemPosititoningType

var target_transform : Transform2D = Transform2D()

func update_target_transform(item : OrbitItem):
	target_transform.origin = item.global_position - item.emitter.global_position
	target_transform.rotated(-target_transform.get_rotation() + item.rotation)


