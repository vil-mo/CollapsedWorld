extends Control
class_name SlotUI

const NORMAL_COLOR = Color(1, 1, 1)
const INTERACTED_COLOR = Color(0.5, 0.5, 0.5)

@export var deafult_icon : Texture2D

@onready var icon : TextureRect = $Icon
@onready var frame : TextureRect = $Frame
var stored_item : SlotStorable = null

func _ready() -> void:
	modulate = NORMAL_COLOR
	icon.texture = deafult_icon

func set_interacted_color(val : bool):
	if val:
		icon.modulate = INTERACTED_COLOR
		frame.modulate = INTERACTED_COLOR
	else:
		icon.modulate = NORMAL_COLOR
		frame.modulate = NORMAL_COLOR

func store_item(slot_storable : SlotStorable):
	icon.texture = slot_storable.icon
	stored_item = slot_storable
	
func remove_item():
	stored_item = null
	icon.texture = deafult_icon

func _has_point(point: Vector2) -> bool:
	return Rect2(global_position, size).has_point(point)
