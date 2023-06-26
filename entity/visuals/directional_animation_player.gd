extends AnimationPlayer
class_name DirectionalAnimationPlayer

@export var direction_map : Dictionary = {
	Vector2(1, 0) : "Right",
	Vector2(1, 1) : "RightDown",
	Vector2(0, 1) : "Down",
	Vector2(-1, 1) : "LeftDown",
	Vector2(-1, 0) : "Left",
	Vector2(-1, -1) : "LeftUp",
	Vector2(0, -1) : "Up",
	Vector2(1, -1) : "RightUp",
}

func _ready() -> void:
	for dir in direction_map.keys():
		var value = direction_map[dir]
		direction_map.erase(dir)
		direction_map[dir.normalized()] = value

func play_direction(anim_name: StringName, direction : Vector2, custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false):
	direction = direction.normalized()
	var closest_direction := Vector2.ZERO
	var closest_distance : float = INF
	
	for possible_dir in direction_map:
		var dist = direction.distance_squared_to(possible_dir)
		if dist < closest_distance:
			closest_direction = possible_dir
			closest_distance = dist
	
	play(anim_name + direction_map[closest_direction], custom_blend, custom_speed, from_end)
