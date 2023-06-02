extends Node

# Z-indexes ===============
# -100: backgrounnd
# -10 : rooms ground
# -5  : collectables
# 0   : ysort
# 100 : interface
# ============================

const PlayerScene = preload("res://entity/playable_characters/playable_character.tscn")

@onready var player : PlayableCharacter = PlayerScene.instantiate()

var ITEMS_KEY_INFORMATION := {}

func _init():
	initialize_item_keys("res://items/")

func _ready() -> void:
	await get_tree().physics_frame
	FallenEntitiesManager.drop_entity(player)

func initialize_item_keys(in_directory : String):
	var dir = DirAccess.open(in_directory)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif dir.current_is_dir():
			initialize_item_keys(in_directory + file + "/")
		elif file.ends_with(".tres"):
			var loaded_file = load(in_directory + file)
			if loaded_file is ItemKey:
				assert(! ITEMS_KEY_INFORMATION.has(loaded_file.key), 'Item with key "' + loaded_file.key + '" already exists, file: ' + file)
				ITEMS_KEY_INFORMATION[loaded_file.key] = loaded_file
	
	dir.list_dir_end()

func get_random_point_in_several_polygons(polygons : Array[PackedVector2Array]):
	var triangulated_points : Array[Vector2] = []
	for polygon in polygons:
		for i in Geometry2D.triangulate_polygon(polygon):
			triangulated_points.append(polygon[i])
	var areas : PackedFloat32Array = []
	var all_area := 0.0
	
	for i in range(0, triangulated_points.size(), 3):
		var a = triangulated_points[i]
		var b = triangulated_points[i + 1]
		var c = triangulated_points[i + 2]
		var area = abs(a.x * b.y + b.x * c.y + c.x * a.y - a.y * b.x - b.y * c.x - c.y * a.x) / 2
		areas.append(area)
		all_area += area
	
	var random_triangle := randf_range(0, all_area) 
	var triangle_index := 0
	var current_area := areas[0]
	while current_area <= random_triangle:
		triangle_index += 1
		current_area += areas[triangle_index]
	
	var point := get_random_point_in_triangle(
		triangulated_points[triangle_index * 3],
		triangulated_points[triangle_index * 3 + 1],
		triangulated_points[triangle_index * 3 + 2]
	)
	return point

func get_random_point_in_polygon(polygon : PackedVector2Array) -> Vector2:
	var triangulated := Geometry2D.triangulate_polygon(polygon)
	var areas : PackedFloat32Array = []
	var all_area := 0.0
	
	for i in range(0, triangulated.size(), 3):
		var a = polygon[triangulated[i]]
		var b = polygon[triangulated[i + 1]]
		var c = polygon[triangulated[i + 2]]
		var area = abs(a.x * b.y + b.x * c.y + c.x * a.y - a.y * b.x - b.y * c.x - c.y * a.x) / 2
		areas.append(area)
		all_area += area
	
	var random_triangle := randf_range(0, all_area) 
	var triangle_index := 0
	var current_area := areas[0]
	while current_area <= random_triangle:
		triangle_index += 1
		current_area += areas[triangle_index]
	
	var point := get_random_point_in_triangle(
		polygon[triangulated[triangle_index * 3]],
		polygon[triangulated[triangle_index * 3 + 1]],
		polygon[triangulated[triangle_index * 3 + 2]]
	)
	return point

func get_random_point_in_triangle(p1 : Vector2, p2 : Vector2, p3 : Vector2) -> Vector2:
	var a := p1 - p2
	var b := p3 - p2
	var u1 = randf()
	var u2 = randf()
	if u1 + u2 > 1:
		u1 = 1 - u1
		u2 = 1 - u2
	
	return a * u1 + b * u2 + p2



