extends Status
class_name Effect

var stats : StatManager

var effect_duration_timer : Timer = Timer.new()

func _init(my_stat_list : EffectStats):
	stats = StatManager.new(my_stat_list)

func _ready() -> void:
	add_child(effect_duration_timer)
	effect_duration_timer.timeout.connect(remove)

func applyed():
	effect_duration_timer.start(stats.current_stats.duration)

func applyed_again(tryed_apply_stats : EffectStats):
	pass
