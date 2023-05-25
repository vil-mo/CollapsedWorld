extends TextureRect
class_name SlotUI

@export var deafult_icon : Texture2D

@onready var icon : TextureRect = $Icon

var stored_item : ItemKey = null

const NORMAL_COLOR = Color(1, 1, 1)
const DRAGGED_COLOR = Color(0.5, 0.5, 0.5)

func _ready() -> void:
	modulate = NORMAL_COLOR
	icon.texture = deafult_icon

func store_item(item_key : ItemKey):
	icon.texture = item_key.icon
	stored_item = item_key

func set_dragging(val : bool):
	if val:
		modulate = DRAGGED_COLOR
	else:
		modulate = NORMAL_COLOR

func remove_item():
	stored_item = null
	icon.texture = deafult_icon

func _has_point(point: Vector2) -> bool:
	return Rect2(global_position, size).has_point(point)
