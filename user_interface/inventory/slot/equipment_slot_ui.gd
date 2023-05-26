extends SlotUI
class_name EquipmentSlotUI

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && _has_point(get_global_mouse_position()):
		if event.button_index == MOUSE_BUTTON_LEFT:
			
			if inventory_ui.dragged_slot:
				if inventory_ui.dragged_slot.stored_item.item_type == type:
					if inventory_ui.dragged_slot != self:
						if inventory_ui.dragged_slot is EquipmentSlotUI:
							inventory_ui.swap_slot_items(self, inventory_ui.dragged_slot)
						else:
							inventory_ui.player_inventory.equip_item(inventory_ui.dragged_slot.stored_item, get_index())
						inventory_ui.stop_dragging_slot()
					elif event.pressed:
						inventory_ui.stop_dragging_slot()
			elif event.pressed && stored_item:
				inventory_ui.start_dragging_slot(self)
		
		elif event.button_index == MOUSE_BUTTON_RIGHT && event.pressed && !inventory_ui.dragged_slot && stored_item:
			inventory_ui.player_inventory.unequip_item(stored_item.item_type, get_index())


