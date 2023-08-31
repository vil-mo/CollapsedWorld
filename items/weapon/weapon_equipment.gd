extends Equipment
class_name WeaponEquipment

@export var weapon_scene : PackedScene
var weapon : Entity
var weapon_active : bool = false

func action_used(action : String):
	if action in this_item_use_acitons:
		
		if weapon_active:
			item_used()
		else:
			weapon = entity.emit_projectile(weapon_scene, true, true)
			weapon_active = true
	elif action.begins_with('attack'):
		if weapon && is_instance_valid(weapon):
			weapon.queue_free()
			weapon = null
		weapon_active = false

func item_used():
	weapon.use()
