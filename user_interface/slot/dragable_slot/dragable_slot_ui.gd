extends SlotUI
class_name DragableSlotUI

var dragged_slot : DragableSlotUI = null

func _ready() -> void:
	super()
	EventBus.ui_start_dragging_slot.connect(start_dragging_slot)
	EventBus.ui_stop_dragging_slot.connect(stop_dragging_slot)

func start_dragging_slot(slot : SlotUI):
	if slot == self:
		set_interacted_color(true)
	dragged_slot = slot

func stop_dragging_slot():
	set_interacted_color(false)
	dragged_slot = null
