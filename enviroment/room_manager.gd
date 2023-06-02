extends Node2D
class_name RoomManager

var room_area : Array[PackedVector2Array] = []

@onready var room : Node2D = $Room
@onready var camera : Camera2D = $Camera2D
@onready var room_generation : RoomGeneration = $Room/RoomGeneration
@onready var interface = $Interface

var current_room_number


const Bulle = preload("res://projectiles/test_projectile/test_projectile.tscn")

@export var forest_conditions : GenerationConditions
@export var snow_conditions : GenerationConditions

func _ready():
	FallenEntitiesManager.room_manager = self
	
	create_room(forest_conditions)
	
	camera.follow_node(true, GameManager.player, true)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		create_room(snow_conditions if randf() < 0.5 else forest_conditions)

func next_room():
	pass

func create_room(conditions : GenerationConditions):
	
	room_generation.generate_room(conditions)
	
	room_area.clear()
	
	for cell in room_generation.get_used_cells_by_id(RoomGeneration.BASE_LAYER, -1, RoomGeneration.tiles.ground):
		var tile_data := room_generation.get_cell_tile_data(RoomGeneration.GROUND_LAYER, cell)
		var nav_vertices := tile_data.get_navigation_polygon(RoomGeneration.GROUND_NAVIGATION_LAYER).get_vertices()
		var cell_pos := room_generation.map_to_local(cell)
		for i in nav_vertices.size():
			nav_vertices[i] += cell_pos
		
		room_area.append(nav_vertices)

func remove_room():
	room_generation.remove_room()

func add_instance(instance : Node2D):
	room.add_child(instance)

func get_random_point() -> Vector2:
	return GameManager.get_random_point_in_several_polygons(room_area)







