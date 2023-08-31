extends Fighter
class_name Player

@onready var directional_animation_player : DirectionalAnimationPlayer = $Visuals/DirectionalAnimationPlayer
var inventory = Inventory.new()

func _ready() -> void:
	super()
	
	inventory.item_equiped.connect(equip)
	inventory.item_unequiped.connect(unequip)
	inventory.equiped_items_swaped.connect(eqipment_swaped)

func _physics_process(delta: float) -> void:
	super(delta)

func eqipment_swaped(item1 : ItemKey, item2 : ItemKey, index1 : int, index2 : int):
	if item1 == item2:
		return
	
	var item_type
	if item1:
		item_type = item1.item_type
	else:
		item_type = item2.item_type
	
	var action1 := _equipment_slot_to_action(item_type, index1)
	var action2 := _equipment_slot_to_action(item_type, index2)
	
	if item1:
		var equipment1 = item1.equipment_instance
		equipment1.this_item_use_acitons.erase(action1)
		equipment1.this_item_use_acitons.append(action2)
	if item2:
		var equipment2 = item2.equipment_instance
		equipment2.this_item_use_acitons.erase(action2)
		equipment2.this_item_use_acitons.append(action1)

func equip(item_key : ItemKey, index : int):
	var item_type = item_key.item_type
	var equipment_instance : Equipment
	
	if item_key.equipment_instance:
		equipment_instance = item_key.equipment_instance
	else:
		equipment_instance = apply_status(item_key.equipment)
		item_key.equipment_instance = equipment_instance
	
	var action_of_this_equipment := _equipment_slot_to_action(item_type, index)
	equipment_instance.this_item_use_acitons.append(action_of_this_equipment)

func unequip(item_key : ItemKey, index : int):
	var equipment_instance = item_key.equipment_instance
	
	if inventory.equiped[item_key.item_type].has(item_key):
		var action_of_this_equipment := _equipment_slot_to_action(item_key.item_type, index)
		equipment_instance.this_item_use_acitons.erase(action_of_this_equipment)
	else:
		remove_status(equipment_instance)
		item_key.equipment_instance = null

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
