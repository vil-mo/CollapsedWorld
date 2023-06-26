extends Equipment

@export var skill_rollback : float
@export var speed_boost_stats : SpeedBoostStats

var skill_rollback_timer : Timer = Timer.new()

func _ready() -> void:
	add_child(skill_rollback_timer)
	skill_rollback_timer.timeout.connect(end_use_effect)

func item_used():
	var effect_impact := ApplyEffectImpact.new(speed_boost_stats)
	entity.apply_impact(effect_impact)
	
	skill_rollback_timer.start(skill_rollback)
	usable = false

func end_use_effect():
	usable = true
