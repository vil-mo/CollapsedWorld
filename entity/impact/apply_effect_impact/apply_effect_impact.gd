extends Impact
class_name ApplyEffectImpact

@export var effect_stats : EffectStats

func _init(my_effect_stats : EffectStats = null):
	if my_effect_stats:
		effect_stats = my_effect_stats

func apply(entity : Entity):
	var effect_script : Script = effect_stats.corresponding_effect
	var same_effect_on_player : Effect = entity.status_mahcine.get_status_with_script(effect_script)
	
	if same_effect_on_player:
		same_effect_on_player.applyed_again(effect_stats)
	else:
		var effect = effect_stats.corresponding_effect.new(effect_stats)
		entity.status_mahcine.apply(effect)
