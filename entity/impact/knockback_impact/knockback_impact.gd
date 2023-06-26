extends Impact
class_name KnockbackImpact

@export var knockback_stats : KnockbackStats
var direction : Vector2
var stats : StatManager

func _init(new_direction : Vector2):
	direction = new_direction.normalized()
	stats = StatManager.new(knockback_stats)

func apply(entity : Entity):
	entity.velocity = knockback_stats.direction * knockback_stats.strenght
