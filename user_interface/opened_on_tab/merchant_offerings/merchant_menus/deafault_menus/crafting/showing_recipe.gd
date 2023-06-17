extends HBoxContainer

const ShowingRecipeSlot = preload("res://user_interface/slot/crafting/showing_recipe_slot.tscn")

func _ready() -> void:
	EventBus.crafting_update_recipe_showing.connect(update_recipe_showing)

func update_recipe_showing(recipe : Recipe):
	for c in get_children():
		remove_child(c)
		c.queue_free()
	
	for item in recipe.ingridients:
		var slot = ShowingRecipeSlot.instantiate()
		add_child(slot)
		slot.initialize(item, recipe.ingridients[item])
