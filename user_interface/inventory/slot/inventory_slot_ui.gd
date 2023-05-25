extends SlotUI
class_name InventorySlotUI

@export var show_item_amount := true
@export var can_be_dragged := true

@onready var amount_label : Label = $Amount

func _input(event: InputEvent) -> void:
	if can_be_dragged && stored_item && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && _has_point(get_global_mouse_position()):
		var inventory_ui : InventoryUI = GameManager.room_manager.interface.inventory
		if inventory_ui.dragged_slot:
			if inventory_ui.dragged_slot.stored_item.item_type == stored_item.item_type && !inventory_ui.dragged_slot is EquipmentSlotUI:
				if inventory_ui.dragged_slot != self:
					inventory_ui.swap_slot_items(self, inventory_ui.dragged_slot)
					inventory_ui.stop_dragging_slot()
				elif event.pressed:
					inventory_ui.stop_dragging_slot()
		elif event.pressed:
			inventory_ui.start_dragging_slot(self)


func _physics_process(delta: float) -> void:
	if show_item_amount && stored_item && stored_item.amount > 1:
		amount_label.visible = true
		amount_label.text = str(stored_item.amount)
	else:
		amount_label.visible = false
