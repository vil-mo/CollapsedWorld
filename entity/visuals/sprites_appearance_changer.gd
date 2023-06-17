extends EntityVisualsSpritesOrdering

@export var appearance : Dictionary = {
	"Right" : {
		"head" : preload("res://entity/player/sprites/head/head1.png"),
		"torso" : preload("res://entity/player/sprites/torso/torso1.png"),
		"leg_left" : preload("res://entity/player/sprites/leg_left/leg_left1.png"),
		"leg_right" : preload("res://entity/player/sprites/leg_right/leg_right1.png"),
	}, 
	"RightDown" : {
		"head" : preload("res://entity/player/sprites/head/head2.png"),
		"torso" : preload("res://entity/player/sprites/torso/torso2.png"),
		"leg_left" : preload("res://entity/player/sprites/leg_left/leg_left2.png"),
		"leg_right" : preload("res://entity/player/sprites/leg_right/leg_right2.png"),
	}, 
	"Down" : {
		"head" : preload("res://entity/player/sprites/head/head3.png"),
		"torso" : preload("res://entity/player/sprites/torso/torso3.png"),
		"leg_left" : preload("res://entity/player/sprites/leg_left/leg_left3.png"),
		"leg_right" : preload("res://entity/player/sprites/leg_right/leg_right3.png"),
	}, 
	"LeftDown" : {
		"head" : preload("res://entity/player/sprites/head/head4.png"),
		"torso" : preload("res://entity/player/sprites/torso/torso4.png"),
		"leg_left" : preload("res://entity/player/sprites/leg_left/leg_left4.png"),
		"leg_right" : preload("res://entity/player/sprites/leg_right/leg_right4.png"),
	},
	"Left" : {
		"head" : preload("res://entity/player/sprites/head/head5.png"),
		"torso" : preload("res://entity/player/sprites/torso/torso5.png"),
		"leg_left" : preload("res://entity/player/sprites/leg_left/leg_left5.png"),
		"leg_right" : preload("res://entity/player/sprites/leg_right/leg_right5.png"),
	},
	"LeftUp" : {
		"head" : preload("res://entity/player/sprites/head/head6.png"),
		"torso" : preload("res://entity/player/sprites/torso/torso6.png"),
		"leg_left" : preload("res://entity/player/sprites/leg_left/leg_left6.png"),
		"leg_right" : preload("res://entity/player/sprites/leg_right/leg_right6.png"),
	},
	"Up" : {
		"head" : preload("res://entity/player/sprites/head/head7.png"),
		"torso" : preload("res://entity/player/sprites/torso/torso7.png"),
		"leg_left" : preload("res://entity/player/sprites/leg_left/leg_left7.png"),
		"leg_right" : preload("res://entity/player/sprites/leg_right/leg_right7.png"),
	},
	"RightUp" : {
		"head" : preload("res://entity/player/sprites/head/head8.png"),
		"torso" : preload("res://entity/player/sprites/torso/torso8.png"),
		"leg_left" : preload("res://entity/player/sprites/leg_left/leg_left8.png"),
		"leg_right" : preload("res://entity/player/sprites/leg_right/leg_right8.png"),
	},
}
@export var appearance_directions : Dictionary = {
	Vector2.RIGHT   : "Right",
	Vector2(1, 1)   : "RightDown",
	Vector2.DOWN    : "Down",
	Vector2(-1, 1)  : "LeftDown",
	Vector2.LEFT    : "Left",
	Vector2(-1, -1) : "LeftUp",
	Vector2.UP      : "Up",
	Vector2(1, -1)  : "RightUp",
}
@export var sprites : Dictionary = {
	"head" : null,
	"torso" : null,
	"leg_left" : null,
	"leg_right" : null,
}

var current_appearance_direction := Vector2.RIGHT

func _ready() -> void:
	for dir in appearance_directions.keys():
		var value = appearance_directions[dir]
		appearance_directions.erase(dir)
		appearance_directions[dir.normalized()] = value
	
	for key in sprites:
		sprites[key] = get_node(sprites[key])

func set_sprites_to_appearance(direction : Vector2):
	current_appearance_direction = direction
	
	var closest_direction := Vector2.ZERO
	var closest_distance : float = INF
	direction = direction.normalized()
	
	for possible_dir in appearance_directions:
		var dist = direction.distance_squared_to(possible_dir)
		if dist < closest_distance:
			closest_direction = possible_dir
			closest_distance = dist
	
	for key in sprites:
		sprites[key].texture = appearance[appearance_directions[closest_direction]][key]
