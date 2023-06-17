extends OpenedOnTab
class_name InventoryUI

const DRAGGED_ITEM_ICON_OFFSET = Vector2(-25, -25)

var slots_parents : Dictionary = {}
var dragged_slot : SlotUI = null

@onready var dragged_item_icon : TextureRect = $DraggedItemIcon

func _ready() -> void:
	super()
	EventBus.ui_start_dragging_slot.connect(start_dragging_slot)
	EventBus.ui_stop_dragging_slot.connect(stop_dragging_slot)
	EventBus.ui_update_inventory.connect(update_inventory)
	EventBus.ui_initial_set_inventory_slots_parent.connect(set_slots_parent)

func _input(event: InputEvent) -> void:
	if dragged_slot && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
		EventBus.ui_stop_dragging_slot.emit()

func _physics_process(delta: float) -> void:
	if dragged_slot:
		dragged_item_icon.global_position = get_global_mouse_position() + DRAGGED_ITEM_ICON_OFFSET

func set_slots_parent(type, parent):
	slots_parents[type] = parent

func start_dragging_slot(slot : SlotUI):
	dragged_slot = slot
	dragged_item_icon.texture = slot.stored_item.icon

func stop_dragging_slot():
	dragged_slot = null
	dragged_item_icon.texture = null

func update_inventory(items : Dictionary):
	for type in slots_parents:
		var slots_parent : Control = slots_parents[type]
		var items_of_type = items[type]
		
		var wanted_slot_amount = items_of_type.size() + 1
		var current_slot_amount = slots_parent.get_child_count()
		
		while current_slot_amount > wanted_slot_amount:
			slots_parent.get_child(current_slot_amount - 1).queue_free()
			current_slot_amount -= 1
		while current_slot_amount < wanted_slot_amount:
			var duplicated = slots_parent.get_child(current_slot_amount - 1).duplicate()
			slots_parent.add_child(duplicated)
			current_slot_amount += 1
	
	EventBus.ui_update_inventory_slots_content.emit(items)
