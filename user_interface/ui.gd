extends CanvasLayer

@onready var inventory := $Control/Inventory

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("open_inventory"):
		if inventory.is_open:
			close_inventory()
		else:
			open_inventory()


func open_inventory():
	inventory.open()

func close_inventory():
	inventory.close()
