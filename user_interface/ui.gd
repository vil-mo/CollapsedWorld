extends CanvasLayer

var is_inventory_open := false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("open_inventory"):
		if is_inventory_open:
			EventBus.ui_close_inventory.emit()
			is_inventory_open = false
		else:
			EventBus.ui_open_inventory.emit()
			is_inventory_open = true

