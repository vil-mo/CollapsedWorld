extends Node2D
class_name RoomManager

var room_area : Array[PackedVector2Array] = []

@onready var room : Node2D = $Room
@onready var instances : Node2D = $Room/Instances
@onready var camera : Camera2D = $Camera2D
@onready var room_generation : RoomGeneration = $Room/RoomGeneration
@onready var interface = $Interface

var current_room_number := 0

var conditions : GenerationConditions = GenerationConditions.new()

func _ready():
	FallenEntitiesManager.room_manager = self
	EventBus.player_entered_door.connect(on_player_entered_door)
	
	next_room(GenerationConditions.BIOMS.FOREST)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		EventBus.player_beat_room.emit()

func on_player_entered_door(biome : GenerationConditions.BIOMS):
	next_room(biome)

func next_room(biome : GenerationConditions.BIOMS):
	camera.follow_node(null)
	conditions.biome = biome
	
	if current_room_number > 0:
		room.position.y = 0
		
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_EXPO)\
		.tween_property(room, "position:y", -720, 1)
		await tween.finished
		
		remove_room()
	
	if GameManager.player.is_inside_tree():
		remove_instance(GameManager.player)
	
	create_room(conditions)
	
	room.position.y = 720
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_SINE)\
	.tween_property(room, "position:y", 0, 1)
	
	await tween.finished
	camera.follow_node(GameManager.player)
	current_room_number += 1
	GameManager.drop_player()

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
	instances.add_child(instance)

func remove_instance(instance : Node2D):
	instances.remove_child(instance)

func get_random_point() -> Vector2:
	return GameManager.get_random_point_in_several_polygons(room_area)

func free_all_instances():
	for instance in instances.get_children():
		instance.queue_free()





