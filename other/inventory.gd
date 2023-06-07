extends Object
class_name Inventory

var max_accesories : int = 3

var items : Dictionary = {
	ItemKey.ITEM_TYPE.ARMOR : [],
	ItemKey.ITEM_TYPE.WEAPON : [],
	ItemKey.ITEM_TYPE.ACCESSORY : [],
	ItemKey.ITEM_TYPE.RELIC : [],
	ItemKey.ITEM_TYPE.MATERIAL : [],
	ItemKey.ITEM_TYPE.CURRENCY : [],
} 
var equiped : Dictionary = {
	ItemKey.ITEM_TYPE.ARMOR : [],
	ItemKey.ITEM_TYPE.WEAPON : [],
	ItemKey.ITEM_TYPE.ACCESSORY : [],
}

func _init() -> void:
	equiped[ItemKey.ITEM_TYPE.ARMOR].resize(1)
	equiped[ItemKey.ITEM_TYPE.WEAPON].resize(2)
	equiped[ItemKey.ITEM_TYPE.ACCESSORY].resize(max_accesories)
	
	EventBus.inventory_swap_inventory_slots.connect(swap_item_places)
	EventBus.inventory_swap_equipment_slots.connect(swap_equiped_item_places)
	EventBus.inventory_equip_in_slot.connect(equip_item)
	EventBus.inventory_try_to_equip_in_any_slot.connect(equip_item_in_first_empty_slot)
	EventBus.inventory_unequip_slot.connect(unequip_item)

func add_item(item_key : ItemKey, amount : int) -> void:
	var this_item_type_items : Array = items[item_key.item_type]
	
	if ! item_key in this_item_type_items:
		this_item_type_items.append(item_key)
		item_key.amount = 0
		
		EventBus.ui_update_inventory.emit(items)
	item_key.amount += amount

func remove_item(item_key : ItemKey, amount : int) -> void:
	var this_item_type_items : Array[ItemKey] = items[item_key.item_type]
	
	item_key.amount -= amount
	
	if item_key in this_item_type_items && item_key.amount <= 0:
		this_item_type_items.erase(item_key)
		item_key.amount = 0
		
		unequip_all_item(item_key)
		EventBus.ui_update_inventory.emit(items)

func swap_item_places(type : ItemKey.ITEM_TYPE, index_from : int = 0, index_to : int = 0):
	var item_from : ItemKey = items[type][index_from]
	items[type][index_from] = items[type][index_to]
	items[type][index_to] = item_from
	
	EventBus.ui_update_inventory.emit(items)

func swap_equiped_item_places(type : ItemKey.ITEM_TYPE, index_from : int = 0, index_to : int = 0):
	var item_from : ItemKey = equiped[type][index_from]
	equiped[type][index_from] = equiped[type][index_to]
	equiped[type][index_to] = item_from
	
	EventBus.ui_update_equipped.emit(equiped)

func is_item_equiped(item_key : ItemKey):
	return item_key in equiped[item_key.item_type]

func equip_item(item_key : ItemKey, index : int):
	var slot_type = item_key.item_type
	
	if equiped[slot_type][index]:
		unequip_item(slot_type, index)
	equiped[slot_type][index] = item_key
	
	EventBus.ui_update_equipped.emit(equiped)

func equip_item_in_first_empty_slot(item_key : ItemKey):
	
	if equiped.has(item_key.item_type):
		var index : int
		for i in equiped[item_key.item_type].size():
			index = i
			if !equiped[item_key.item_type][i]:
				break
		
		equip_item(item_key, index)

func unequip_all_item(item_key : ItemKey):
	while item_key in equiped[item_key.item_type]:
		equiped[item_key.item_type].erase(item_key)

func unequip_item(type : ItemKey.ITEM_TYPE, index : int) -> void:
	equiped[type][index] = null
	
	EventBus.ui_update_equipped.emit(equiped)

