extends Fighter
class_name Player


@onready var directional_animation_player : DirectionalAnimationPlayer = $Visuals/DirectionalAnimationPlayer
var inventory = Inventory.new()

func _ready() -> void:
	super()
	
	inventory.item_equiped.connect(equip)
	inventory.item_unequiped.connect(unequip)

func equip(item_key : ItemKey, index : int):
	var item_type = item_key.item_type
	var equipment_instance : Equipment = apply_status(item_key.equipment)
	
	var action_of_this_equipment := _equipment_slot_to_action(item_type, index)
	equipment_instance.this_item_use_acitons = [action_of_this_equipment] as Array[String]
	
	item_key.equipment_instance = equipment_instance

func unequip(item_key : ItemKey):
	var equipment = item_key.equipment_instance
	remove_status(equipment)

func _action_to_equipment_slot(action : String) -> ItemKey:
	var equiped_key : ItemKey
	if action == "armor":
		equiped_key = inventory.equiped[ItemKey.ITEM_TYPE.ARMOR][0]
	elif action == "attack1":
		equiped_key = inventory.equiped[ItemKey.ITEM_TYPE.WEAPON][0]
	elif action == "attack2":
		equiped_key = inventory.equiped[ItemKey.ITEM_TYPE.WEAPON][1]
	elif action == "accessory1":
		equiped_key = inventory.equiped[ItemKey.ITEM_TYPE.ACCESSORY][0]
	elif action == "accessory2":
		equiped_key = inventory.equiped[ItemKey.ITEM_TYPE.ACCESSORY][1]
	elif action == "accessory3":
		equiped_key = inventory.equiped[ItemKey.ITEM_TYPE.ACCESSORY][2]
	return equiped_key

func _equipment_slot_to_action(item_type : ItemKey.ITEM_TYPE, index : int) -> String:
	var action : String
	if item_type == ItemKey.ITEM_TYPE.ARMOR:
		action = "armor"
	elif item_type == ItemKey.ITEM_TYPE.WEAPON:
		if index == 0:
			action = "attack1"
		elif index == 1:
			action = "attack2"
	elif item_type == ItemKey.ITEM_TYPE.ACCESSORY:
		if index == 0:
			action = "accessory1"
		elif index == 1:
			action = "accessory2"
		elif index == 2:
			action = "accessory3"
	
	return action
