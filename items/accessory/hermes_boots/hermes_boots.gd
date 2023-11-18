extends Equipment

@export var skill_rollback : float
@export var speed_boost_stats : SpeedBoostStats

var skill_rollback_timer : Timer = Timer.new()

func _ready() -> void:
	add_child(skill_rollback_timer)
	skill_rollback_timer.timeout.connect(end_use_effect)

func item_used():
	
	
	
	skill_rollback_timer.start(skill_rollback)
	usable = false

func end_use_effect():
	usable = true
