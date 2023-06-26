extends EffectStats
class_name SpeedBoostStats

@export var boost_amount : float = 0.2


func _init():
	corresponding_effect = SpeedBoostEffect
