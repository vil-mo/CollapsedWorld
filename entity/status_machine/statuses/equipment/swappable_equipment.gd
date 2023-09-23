extends OrbitItemEquipment
class_name SwappableEquipment

@export var weapon_positioning_type : OrbitItemPosititoningType
@export var weapon_using_type : OrbitItemUsingType
@onready var weapon : OrbitItem = OrbitItemScene.instantiate()
var weapon_active : bool = false

const OrbitItemScene = preload("res://entity/content/orbit_item/orbit_item.tscn")




func action_used(action : String):
	if action in this_item_use_acitons:
		
		if weapon_active:
			item_used()
		else:
			emit_weapon()
			weapon_active = true
	elif action.begins_with('attack'):
		if weapon && is_instance_valid(weapon):
			weapon.queue_free()
			weapon = null
		weapon_active = false

func emit_weapon():
	weapon = entity.emit_projectile(OrbitItemScene, true, true)
	

