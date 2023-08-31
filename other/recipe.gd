extends Resource
class_name Recipe

@export var amount_crafted : int = 1
@export var ingridients : Dictionary

var result : ItemKey
var progression_point : float
var biome_flags : int




func can_be_crafted() -> bool:
	for key in ingridients:
		if key.amount < ingridients[key]:
			return false
	
	return true

func has_some_ingridients() -> bool:
	for key in ingridients:
		if key.amount != 0:
			return true
	
	return false
