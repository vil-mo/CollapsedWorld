extends Status

@export var use_effect_speed_increace : float = 0.5
@export var use_effect_time : float = 5

var speed_increace_buff : Stats = Stats.new()
var use_effect_timer : Timer = Timer.new()

func _ready() -> void:
	speed_increace_buff.walking_speed = use_effect_speed_increace
	add_child(use_effect_timer)
	use_effect_timer.timeout.connect(end_use_effect)

func use(_by_action : String):
	entity.stats.add_buff(speed_increace_buff)
	use_effect_timer.start(use_effect_time)
	use_effect_timer.start()
	usable = false

func end_use_effect():
	entity.stats.remove_buff(speed_increace_buff)
	usable = true
