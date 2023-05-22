extends CanvasLayer

@onready var animation : AnimationPlayer = $AnimationPlayer
var inventory_apeared := false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("open_inventory"):
		if inventory_apeared:
			inventory_apeared = false
			animation.play("InventoryDissapear")
		else:
			inventory_apeared = true				
			animation.play("InventoryAppear")
	
