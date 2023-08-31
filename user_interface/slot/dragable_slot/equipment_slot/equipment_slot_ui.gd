extends DragableSlotUI
class_name EquipmentSlotUI

@export var type : ItemKey.ITEM_TYPE

func _ready() -> void:
	super()
	EventBus.ui_update_equiped.connect(update_content)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && _has_point(get_global_mouse_position()):
		if event.button_index == MOUSE_BUTTON_LEFT:
			if dragged_slot:
				if dragged_slot.type == type:
					if dragged_slot != self:
						if dragged_slot is EquipmentSlotUI:
							EventBus.inventory_swap_equipment_slots.emit(type, get_index(), dragged_slot.get_index())
						else:
							EventBus.inventory_equip_in_slot.emit(dragged_slot.stored_item, get_index())
						EventBus.ui_stop_dragging_slot.emit()
					elif event.pressed:
						EventBus.ui_stop_dragging_slot.emit()
			elif event.pressed && stored_item:
				EventBus.ui_start_dragging_slot.emit(self)
		
		elif event.button_index == MOUSE_BUTTON_RIGHT && event.pressed && !dragged_slot && stored_item:
			EventBus.inventory_unequip_slot.emit(stored_item.item_type, get_index())

func update_content(equiped : Dictionary):
	var item = equiped[type][get_index()]
	if item:
		store_item(item)
	else:
		remove_item()
