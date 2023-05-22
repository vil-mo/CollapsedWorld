extends TextureRect
class_name SlotUI
@onready var itventory_ui : Control = get_parent().get_parent()

@export var deafult_texture : Texture2D
var time_to_remove_item = 1.0


var has_item := false
var is_removing_item := false
var removing_time_counter := 0.0
var index := []

func _ready():
	if not deafult_texture:
		deafult_texture = texture
	else:
		texture = deafult_texture

func _gui_input(event):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && has_item:
		if event.pressed:
			is_removing_item = true
			removing_time_counter = 0
		else:
			is_removing_item = false

func _physics_process(delta):
	if is_removing_item:
		removing_time_counter += get_process_delta_time()
		if removing_time_counter >= time_to_remove_item:
			GameManager.player_node.drop_item(index)
			is_removing_item = false

func add_item(item_key):
	texture = item_key.icon
	has_item = true

func remove_item():
	texture = deafult_texture
	has_item = false
