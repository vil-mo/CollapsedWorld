extends StatList
class_name EffectStats

@export var duration : float

var corresponding_effect : Script

func _to_string():
	return corresponding_effect.get_meta("name", "Nameless effect")
