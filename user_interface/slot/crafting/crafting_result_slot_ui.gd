extends SlotUI

@onready var amount_label : Label = $Amount

func _ready() -> void:
	EventBus.crafting_update_recipe_showing.connect(update_recipe_showing)

func update_recipe_showing(recipe : Recipe):
	store_item(recipe.result)
	amount_label.text = str(recipe.amount_crafted)
