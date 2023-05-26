extends SlotUI
class_name InventorySlotUI

@export var show_item_amount := true
@export var can_be_dragged := true

@onready var amount_label : Label = $Amount

func _input(event: InputEvent) -> void:
	if can_be_dragged && event is InputEventMouseButton && _has_point(get_global_mouse_position()):
		if stored_item:
			if event.button_index == MOUSE_BUTTON_LEFT:
				
				if inventory_ui.dragged_slot:
					if inventory_ui.dragged_slot.stored_item.item_type == type && !inventory_ui.dragged_slot is EquipmentSlotUI:
						if inventory_ui.dragged_slot != self:
							inventory_ui.swap_slot_items(self, inventory_ui.dragged_slot)
							inventory_ui.stop_dragging_slot()
						elif event.pressed:
							inventory_ui.stop_dragging_slot()
				elif event.pressed:
					inventory_ui.start_dragging_slot(self)
			
			elif event.button_index == MOUSE_BUTTON_RIGHT && event.pressed && !inventory_ui.dragged_slot && type in inventory_ui.player_inventory.equiped.keys():
				inventory_ui.player_inventory.equip_item_in_first_empty_slot(stored_item)

func _physics_process(delta: float) -> void:
	if show_item_amount && stored_item && stored_item.amount > 1:
		amount_label.visible = true
		amount_label.text = str(stored_item.amount)
	else:
		amount_label.visible = false


