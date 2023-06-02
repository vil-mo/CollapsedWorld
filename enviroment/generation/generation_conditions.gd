extends Resource
class_name GenerationConditions

enum BIOMS {FOREST, SNOW, JUNGLE, DESERT, CAVE, BEACH}

const BIOM_ROOM_TILE_TEXTURES = {
	BIOMS.FOREST : {1 : preload("res://enviroment/bioms/forest/forest_stage1_tiles.png")},
	BIOMS.SNOW : {1 : preload("res://enviroment/bioms/snow/snow_stage1_tiles.png")},
}


@export var stage : int = 1
@export var biome : BIOMS = BIOMS.FOREST
@export var merchant : Resource = null

@export var size := Vector2i(20, 20)
@export var holes_amount : int = 3
@export var initial_ground_removing_amount : int = 4
@export var initial_ground_chance_to_be_removed : float = 0.17
@export var walls_amount : int = 3
@export var walls_neghbor_amount : int = 4
@export var walls_expanding_amount : int = 1
@export var walls_chance_to_be_expanded : float = 0.2
@export var should_connect_land : bool = true
@export var connecting_land_connection_wideness : float = 1

func get_tile_texture() -> Texture:
	return BIOM_ROOM_TILE_TEXTURES[biome][stage]
