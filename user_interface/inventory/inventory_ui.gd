extends Control
class_name InventoryUI

var slots_ui := {}

func _ready():
	slots_ui[GameManager.ITEM_TYPE.ARMOR] = $ArmorSlots.get_children()
	slots_ui[GameManager.ITEM_TYPE.WEAPON] = $WheaponSlots.get_children()
	slots_ui[GameManager.ITEM_TYPE.ACCESSORY] = $AccessorySlots.get_children()
	
	for i in range(len(slots_ui.keys())):
		for j in range(len(slots_ui[i])):
			slots_ui[i][j].index = [i, j]

func on_inventory_changed(item_key : ItemKey, slot):
	if item_key:
		slots_ui[slot[0]][slot[1]].add_item(item_key)
	else:
		slots_ui[slot[0]][slot[1]].remove_item()
