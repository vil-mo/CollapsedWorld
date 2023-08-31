extends DragableSlotUI
class_name InventorySlotUI

@export var show_item_amount := true
@export var can_be_dragged := true

@export var type : ItemKey.ITEM_TYPE

@onready var amount_label : Label = $Amount

func _ready() -> void:
	super()
	EventBus.ui_update_inventory_slots_content.connect(update_content)
	EventBus.call_deferred("emit_signal", "ui_initial_set_inventory_slots_parent", type, get_parent())

func _input(event: InputEvent) -> void:
	if can_be_dragged && event is InputEventMouseButton && _has_point(get_global_mouse_position()):
		if stored_item:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if dragged_slot:
					if dragged_slot.type == type && !dragged_slot is EquipmentSlotUI:
						if dragged_slot != self:
							EventBus.inventory_swap_inventory_slots.emit(type, get_index(), dragged_slot.get_index())
							EventBus.ui_stop_dragging_slot.emit()
						elif event.pressed:
							EventBus.ui_stop_dragging_slot.emit()
				elif event.pressed:
					EventBus.ui_start_dragging_slot.emit(self)
			
			elif event.button_index == MOUSE_BUTTON_RIGHT && event.pressed && !dragged_slot:
				EventBus.inventory_try_to_equip_in_any_slot.emit(stored_item)
				

func update_content(items : Dictionary):
	var items_of_type = items[type]
	var index = get_index()
	if items_of_type.size() > index:
		store_item(items_of_type[index])
	else:
		remove_item()

func _physics_process(delta: float) -> void:
	if show_item_amount && stored_item && stored_item.amount > 1:
		amount_label.visible = true
		amount_label.text = str(stored_item.amount)
	else:
		amount_label.visible = false


