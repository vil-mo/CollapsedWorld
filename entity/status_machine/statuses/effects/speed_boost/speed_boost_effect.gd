extends Effect
class_name SpeedBoostEffect

var entity_buff := FighterStats.new()

func applyed():
	super()
	entity_buff.speed = stats.current_stats.boost_amount
	entity.stats.add_buff(entity_buff)

func applyed_again(tryed_apply_stats : EffectStats):
	stats.base_stats = tryed_apply_stats
	entity_buff.speed = stats.current_stats.boost_amount
	effect_duration_timer.start(stats.current_stats.duration)

func removed():
	entity.stats.remove_buff(entity_buff)
