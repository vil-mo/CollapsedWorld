extends Node2D
class_name RoomManager

var current_room : StaticBody2D = null
var safe_areas : Array[PackedVector2Array] = []

@onready var interface = $Interface
@onready var camera := $Camera2D

signal room_created(room)

const Bulle = preload("res://projectiles/test_projectile/test_projectile.tscn")

func _ready():
	GameManager.room_manager = self
	FallenEntitiesManager.room_manager = self
	
	create_room()
	

func create_room(criterias := {}):
	if current_room:
		remove_room()
	
	var rooms := get_list_of_rooms(criterias)
	var packed_room : PackedScene = rooms[randi() % len(rooms)]
	var room : StaticBody2D = packed_room.instantiate()
	
	room.position = Vector2.ZERO
	add_child(room)
	current_room = room
	
	safe_areas = []
	for i in current_room.get_node("SafeAreas").get_children():
		safe_areas.append(i.polygon)
	
	emit_signal("room_created", room)

func remove_room():
	current_room.queue_free()
	current_room = null

func add_instance(instance : Node2D):
	current_room.add_child(instance)
	

func get_random_point() -> Vector2:
	return GameManager.get_random_point_in_several_polygons(safe_areas)

func get_list_of_rooms(criterias := {}) -> Array[PackedScene]:
	return [load("res://rooms/test/TestRoom1.tscn") as PackedScene] #, load("res://rooms/test/TestRoom2.tscn") as PackedScene, load("res://rooms/test/TestRoom3.tscn") as PackedScene]





