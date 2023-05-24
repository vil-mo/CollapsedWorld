extends Control
class_name InventoryUI

@export var armor_slots : Control
@export var weapon_slots : Control
@export var accessory_slots : Control
@export var material_slots : Control

@onready var dragged_item_icon : TextureRect = $DraggedItemIcon

var dragged_item : ItemKey = null

func _physics_process(delta: float) -> void:
	if dragged_item:
		dragged_item_icon.global_position = get_global_mouse_position()

func start_dragging_item(item : ItemKey):
	dragged_item = item
	dragged_item_icon.texture = item.icon

func stop_dragging_item():
	dragged_item = null
	dragged_item_icon.texture = null

func update_slots(type, array : Array):
	
	var slots_parent : Control
	
	match type:
		ItemKey.ITEM_TYPE.ARMOR:
			slots_parent = armor_slots
		ItemKey.ITEM_TYPE.WEAPON:
			slots_parent = weapon_slots
		ItemKey.ITEM_TYPE.ACCESSORY:
			slots_parent = accessory_slots
		ItemKey.ITEM_TYPE.MATERIAL:
			slots_parent = material_slots
	
	var wanted_slot_amount = array.size() + 1
	var current_slot_amount = slots_parent.get_child_count()
	
	while current_slot_amount > wanted_slot_amount:
		slots_parent.get_child(current_slot_amount - 1).queue_free()
		current_slot_amount -= 1
	while current_slot_amount < wanted_slot_amount:
		slots_parent.add_child(slots_parent.get_child(current_slot_amount - 1).duplicate())
		current_slot_amount += 1
	
	var slots = slots_parent.get_children()
	for i in current_slot_amount:
		if i < wanted_slot_amount - 1:
			slots[i].store_item(array[i])
		else:
			slots[i].remove_item()
