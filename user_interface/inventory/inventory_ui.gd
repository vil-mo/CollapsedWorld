extends Control
class_name InventoryUI

@export var armor_slots : Control
@export var weapon_slots : Control
@export var accessory_slots : Control
@export var material_slots : Control
@export var relic_slots : Control

@export var equipment_armor_slots : Control
@export var equipment_weapon_slots : Control
@export var equipment_accessory_slots : Control

@onready var dragged_item_icon : TextureRect = $DraggedItemIcon
const DRAGGED_ITEM_ICON_OFFSET = Vector2(-25, -25)

var dragged_slot : SlotUI = null
var is_open := false
var player_inventory : Inventory

func _ready() -> void:
	await get_tree().physics_frame
	player_inventory = GameManager.player.inventory

func _input(event: InputEvent) -> void:
	if dragged_slot && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
		stop_dragging_slot()

func _physics_process(delta: float) -> void:
	if dragged_slot:
		dragged_item_icon.global_position = get_global_mouse_position() + DRAGGED_ITEM_ICON_OFFSET	

func start_dragging_slot(slot : SlotUI):
	slot.set_dragging(true)
	dragged_slot = slot
	dragged_item_icon.texture = slot.stored_item.icon

func stop_dragging_slot():
	dragged_slot.set_dragging(false)
	dragged_slot = null
	dragged_item_icon.texture = null

func update_slots(type):
	var array = player_inventory.items[type]
	
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
		ItemKey.ITEM_TYPE.RELIC:
			slots_parent = relic_slots
	
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

func update_equiped_items():
	var equiped = player_inventory.equiped
	for type in equiped.keys():
		var slots_parent
		match type:
			ItemKey.ITEM_TYPE.ARMOR:
				slots_parent = equipment_armor_slots
			ItemKey.ITEM_TYPE.WEAPON:
				slots_parent = equipment_weapon_slots
			ItemKey.ITEM_TYPE.ACCESSORY:
				slots_parent = equipment_accessory_slots
		var slots = slots_parent.get_children()
		for i in equiped[type].size():
			if equiped[type][i]:
				slots[i].store_item(equiped[type][i])
			else:
				slots[i].remove_item()

func eqip_item_in_slot(from_slot : SlotUI, to_slot : SlotUI):
	pass

func swap_slot_items(slot1 : SlotUI, slot2 : SlotUI):
	assert(slot1.type == slot2.type, "Slots of different type tryed to be swaped")
	var item1 = slot1.stored_item
	var item2 = slot2.stored_item
	
	if item2:
		slot1.store_item(item2)
	else:
		slot1.remove_item()
	if item1:
		slot2.store_item(item1)
	else:
		slot2.remove_item()
	
	if slot1 is InventorySlotUI:
		player_inventory.swap_item_places(slot1.type, slot1.get_index(), slot2.get_index())
	else:
		player_inventory.swap_equiped_item_places(slot1.type, slot1.get_index(), slot2.get_index())
