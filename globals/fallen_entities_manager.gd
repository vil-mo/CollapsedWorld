extends Node

var room_manager : RoomManager

var fallen_entities : Array[Entity] = []

func entity_fell(entity : Entity, should_drop_after : float = 1):
	fallen_entities.append(entity)

	entity.get_parent().remove_child(entity)
	
	if should_drop_after > 0:
		await get_tree().create_timer(should_drop_after).timeout
		drop_entity(entity)

func drop_entity(entity : Entity, in_point : Vector2 = Vector2.INF):
	if in_point == Vector2.INF:
		in_point = room_manager.get_random_point()
	
	fallen_entities.erase(entity)
	var effect : Node2D = entity.drop_effect.instantiate()
	
	effect.global_position = in_point
	room_manager.add_instance(effect)
	await get_tree().create_timer(effect.get_meta("time_to_end", 1)).timeout
	effect.queue_free()
	entity.global_position = in_point
	room_manager.add_instance(entity)
	
	entity.is_fell = false
