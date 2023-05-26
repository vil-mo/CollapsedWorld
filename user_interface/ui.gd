extends CanvasLayer

@onready var inventory := $Control/Inventory

@onready var animation : AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("open_inventory"):
		if inventory.is_open:
			close_inventory()
		else:
			open_inventory()


func open_inventory():
	inventory.is_open = true
	animation.play("InventoryAppear")
func close_inventory():
	inventory.is_open = false
	animation.play("InventoryDissapear")
