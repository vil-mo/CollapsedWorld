extends SlotUI
class_name CraftingSlotUI

var stored_recipe : Recipe

@onready var amount_label : Label = $Amount
@onready var selected_icon := $Selected

var is_selected := false

func initialize(recipe : Recipe):
	stored_recipe = recipe
	store_item(recipe.result)
	amount_label.text = str(recipe.amount_crafted)
	unselect()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && _has_point(get_global_mouse_position()):
		if event.pressed && event.button_index == MOUSE_BUTTON_LEFT && stored_recipe.has_some_ingridients:
			if is_selected:
				if stored_recipe.can_be_crafted:
					EventBus.crafting_craft_item.emit(stored_recipe)
			else:
				EventBus.crafting_select_crafting_slot.emit(self)

func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)

func _physics_process(delta: float) -> void:
	visible = stored_recipe.has_some_ingridients
	set_interacted_color(!stored_recipe.can_be_crafted)

func on_mouse_entered():
	EventBus.crafting_mouse_entered_crafting_slot.emit(self)

func on_mouse_exited():
	EventBus.crafting_mouse_exited_crafting_slot.emit(self)

func select():
	selected_icon.visible = true
	is_selected = true

func unselect():
	selected_icon.visible = false
	is_selected = false
