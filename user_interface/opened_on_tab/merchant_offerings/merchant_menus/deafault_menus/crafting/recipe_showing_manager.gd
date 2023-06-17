extends HBoxContainer

var selected_slot : CraftingSlotUI = null:
	set(val):
		if selected_slot:
			selected_slot.unselect()
		selected_slot = val
		selected_slot.select()

func _ready() -> void:
	EventBus.crafting_mouse_entered_crafting_slot.connect(on_mouse_entered)
	EventBus.crafting_mouse_exited_crafting_slot.connect(on_mouse_exited)
	EventBus.crafting_select_crafting_slot.connect(on_mouse_cliked)

func on_mouse_entered(slot : CraftingSlotUI):
	if !selected_slot:
		selected_slot = slot
	EventBus.crafting_update_recipe_showing.emit(slot.stored_recipe)

func on_mouse_exited(slot : CraftingSlotUI):
	EventBus.crafting_update_recipe_showing.emit(selected_slot.stored_recipe)

func on_mouse_cliked(slot : CraftingSlotUI):
	selected_slot = slot
	EventBus.crafting_update_recipe_showing.emit(slot.stored_recipe)
