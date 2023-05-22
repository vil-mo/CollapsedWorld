extends Object
class_name Inventory

enum SLOT_TYPES {ARMOR, WEAPON_1, WEAPON_2, ACCESSORY}

var items : Dictionary = {
	ItemKey.ITEM_TYPE.ARMOR : [],
	ItemKey.ITEM_TYPE.WEAPON : [],
	ItemKey.ITEM_TYPE.ACCESSORY : [],
	ItemKey.ITEM_TYPE.RELIC : [],
	ItemKey.ITEM_TYPE.CRAFTING : [],
} 
var max_accesories : int = 3

var equiped : Dictionary = {}

func add_item(item_key : ItemKey, amount : int) -> void:
	var this_item_type_items : Array[ItemKey] = items[item_key.item_type]
	
	if ! item_key in this_item_type_items:
		this_item_type_items.append(item_key)
		item_key.amount = 0
	item_key.amount += amount

func remove_item(item_key : ItemKey, amount : int) -> void:
	var this_item_type_items : Array[ItemKey] = items[item_key.item_type]
	
	item_key.amount -= amount
	
	if item_key in this_item_type_items && item_key.amount <= 0:
		this_item_type_items.erase(item_key)
		item_key.amount = 0
		
		unequip_item(item_key)

func is_item_equiped(item_key : ItemKey):
	return item_key in equiped.values()

## Returns true if item succesfully returned, false otherwise
func equip_item(item_key : ItemKey, slot = null):
	if !slot:
		match item_key.item_type:
			ItemKey.ITEM_TYPE.ARMOR:
				slot = SLOT_TYPES.ARMOR
			ItemKey.ITEM_TYPE.WEAPON:
				if equiped[SLOT_TYPES.WEAPON_1]:
					slot = SLOT_TYPES.WEAPON_2
				else:
					slot = SLOT_TYPES.WEAPON_1
			ItemKey.ITEM_TYPE.ACCESSORY:
				slot = SLOT_TYPES.ACCESSORY
	
	if equiped[slot]:
		unequip_item(equiped[slot])
	equiped[slot] = item_key

func unequip_item(item_key : ItemKey) -> void:
	if ! is_item_equiped(item_key):
		var slot = equiped.find_key(item_key)
		equiped[slot] = null
