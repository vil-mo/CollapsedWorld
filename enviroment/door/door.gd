extends Node2D
class_name Door

const BIOME_TEXTURES_TOP = {
	GenerationConditions.BIOMS.FOREST : preload("res://enviroment/bioms/forest/forest_stage1_door_top.png"),
	GenerationConditions.BIOMS.SNOW : preload("res://enviroment/bioms/snow/snow_stage1_door_top.png"),
}
const BIOME_TEXTURES_MIDDLE = {
	GenerationConditions.BIOMS.FOREST : preload("res://enviroment/bioms/forest/forest_stage1_door_middle.png"),
	GenerationConditions.BIOMS.SNOW : preload("res://enviroment/bioms/snow/snow_stage1_door_middle.png"),
}
const BIOME_TEXTURES_BOTTOM = {
	GenerationConditions.BIOMS.FOREST : preload("res://enviroment/bioms/forest/forest_stage1_door_bottom.png"),
	GenerationConditions.BIOMS.SNOW : preload("res://enviroment/bioms/snow/snow_stage1_door_bottom.png"),
}
const WALL_COLLISION := 0b1000

var biome : GenerationConditions.BIOMS

@onready var sprite_top = $TopSprite
@onready var sprite_middle = $MiddleSprite
@onready var sprite_bottom = $BottomSprite
@onready var collision = $Collision
@onready var wall_when_closed = $Collision/WallWhenClosed
@onready var player_detector = $Collision/PlayerDetector

func _ready() -> void:
	EventBus.player_beat_room.connect(on_player_beat_room)
	player_detector.body_entered.connect(_on_player_entered)
	

func initialize(direction : Vector2, to_biome : GenerationConditions.BIOMS):
	if direction == Vector2.DOWN:
		sprite_top.frame_coords.x = 0
		sprite_middle.frame_coords.x = 0
		sprite_bottom.frame_coords.x = 0
	elif direction == Vector2.RIGHT:
		sprite_top.frame_coords.x = 1
		sprite_middle.frame_coords.x = 1
		sprite_bottom.frame_coords.x = 1
	elif direction == Vector2.LEFT:
		sprite_top.frame_coords.x = 2
		sprite_middle.frame_coords.x = 2
		sprite_bottom.frame_coords.x = 2
	biome = to_biome
	sprite_top.texture = BIOME_TEXTURES_TOP[to_biome]
	sprite_middle.texture = BIOME_TEXTURES_MIDDLE[to_biome]
	sprite_bottom.texture = BIOME_TEXTURES_BOTTOM[to_biome]
	
	collision.rotation = direction.angle()
	close()


func on_player_beat_room():
	open()

func open():
	wall_when_closed.collision_layer = 0
	sprite_top.frame_coords.y = 0
	sprite_middle.frame_coords.y = 0
	sprite_bottom.frame_coords.y = 0

func close():
	wall_when_closed.collision_layer = WALL_COLLISION
	sprite_top.frame_coords.y = 1
	sprite_middle.frame_coords.y = 1
	sprite_bottom.frame_coords.y = 1


func _on_player_entered(body : Node2D):
	EventBus.player_entered_door.emit(biome)
	player_detector.body_entered.disconnect(_on_player_entered)

