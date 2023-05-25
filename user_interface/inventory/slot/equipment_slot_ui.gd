extends SlotUI
class_name EquipmentSlotUI

@export var type : ItemKey.ITEM_TYPE

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && _has_point(get_global_mouse_position()):
		if event.button_index == MOUSE_BUTTON_LEFT:
			var inventory_ui : InventoryUI = GameManager.room_manager.interface.inventory
			
			if inventory_ui.dragged_slot:
				if inventory_ui.dragged_slot.stored_item.item_type == type:
					if inventory_ui.dragged_slot != self:
						if inventory_ui.dragged_slot is EquipmentSlotUI:
							inventory_ui.swap_slot_items(self, inventory_ui.dragged_slot)
						else:
							store_item(inventory_ui.dragged_slot.stored_item)
						inventory_ui.stop_dragging_slot()
					elif event.pressed:
						inventory_ui.stop_dragging_slot()
			elif event.pressed:
				inventory_ui.start_dragging_slot(self)

		elif event.button_index == MOUSE_BUTTON_MASK_RIGHT:
			remove_item()
