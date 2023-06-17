extends Resource
class_name Attack

enum APPLYING_KNOCKBACK_TYPE {
	ALWAYS_THE_SAME, 
	ALONG_WITH_DIRECTION_OF_PROJECTILE, 
	AWAY_FROM_PROJECTILE, 
	INTO_PROJECTILE, 
	AWAY_FROM_EMITTER, 
	INTO_EMITTER
}

@export var damage : int
@export var knockback_force : float
@export var applying_knockback_type : APPLYING_KNOCKBACK_TYPE = APPLYING_KNOCKBACK_TYPE.AWAY_FROM_PROJECTILE
@export var knockback_offset_angle : float = 0
@export var iframes_duration : float = 0.2

var projectile : Projectile
var emitter : Entity

func get_knockback_vector(to_entity : Entity) -> Vector2:
	var knockback : Vector2
	
	match applying_knockback_type:
		APPLYING_KNOCKBACK_TYPE.ALWAYS_THE_SAME:
			knockback = Vector2.RIGHT
		APPLYING_KNOCKBACK_TYPE.ALONG_WITH_DIRECTION_OF_PROJECTILE:
			knockback = projectile.direction.normalized()
		APPLYING_KNOCKBACK_TYPE.AWAY_FROM_PROJECTILE:
			knockback = projectile.global_position.direction_to(to_entity.global_position)
		APPLYING_KNOCKBACK_TYPE.INTO_PROJECTILE:
			knockback = to_entity.global_position.direction_to(projectile.global_position)
		APPLYING_KNOCKBACK_TYPE.AWAY_FROM_EMITTER:
			knockback = emitter.global_position.direction_to(to_entity.global_position)
		APPLYING_KNOCKBACK_TYPE.INTO_EMITTER:
			knockback = to_entity.global_position.direction_to(emitter.global_position)
	
	return knockback_force * knockback.rotated(deg_to_rad(knockback_offset_angle))
