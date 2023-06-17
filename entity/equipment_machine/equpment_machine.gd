extends Node2D
class_name EquipmentMachine

@onready var equipment : Array = get_children()

func equip(to_equip : Equipment):
	to_equip.entity = owner
	add_child(to_equip)
	to_equip.equiped()
	equipment.append(to_equip)

func unequip(to_equip : Equipment):
	to_equip.unequiped()
	remove_child(to_equip)
	equipment.erase(to_equip)

func use_action(action : String):
	for eq in equipment:
		if eq.usable && eq.actions.has(action):
			eq.use(action)
