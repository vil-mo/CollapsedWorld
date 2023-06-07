extends TextureRect
class_name SlotUI

const NORMAL_COLOR = Color(1, 1, 1)
const DRAGGED_COLOR = Color(0.5, 0.5, 0.5)

@export var deafult_icon : Texture2D
@export var type : ItemKey.ITEM_TYPE

@onready var icon : TextureRect = $Icon

var stored_item : ItemKey = null
var dragged_slot : SlotUI = null

func _ready() -> void:
	modulate = NORMAL_COLOR
	icon.texture = deafult_icon
	
	EventBus.ui_start_dragging_slot.connect(start_dragging_slot)
	EventBus.ui_stop_dragging_slot.connect(stop_dragging_slot)

func start_dragging_slot(slot : SlotUI):
	if slot == self:
		set_dragging(true)
	dragged_slot = slot

func stop_dragging_slot():
	set_dragging(false)
	dragged_slot = null

func set_dragging(val : bool):
	if val:
		modulate = DRAGGED_COLOR
	else:
		modulate = NORMAL_COLOR
		
func store_item(item_key : ItemKey):
	icon.texture = item_key.icon
	stored_item = item_key
	
func remove_item():
	stored_item = null
	icon.texture = deafult_icon

func _has_point(point: Vector2) -> bool:
	return Rect2(global_position, size).has_point(point)
