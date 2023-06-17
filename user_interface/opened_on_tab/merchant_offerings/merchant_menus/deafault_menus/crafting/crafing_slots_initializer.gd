extends HFlowContainer

const CraftingSlotScene = preload("res://user_interface/slot/crafting/crafting_slot_ui.tscn")

func _ready() -> void:
	for recipe in GameLoader.item_recipes:
		var crafitng_slot : CraftingSlotUI = CraftingSlotScene.instantiate()
		add_child(crafitng_slot)
		crafitng_slot.initialize(recipe)
		
