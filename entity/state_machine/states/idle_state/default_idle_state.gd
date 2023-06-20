extends State
class_name DefaultIdleState

@export var reset_velocity_when_moving_in_opposite_direction := true
var movement_direction := Vector2.ZERO

func physics_process_state(delta : float):
	walk(movement_direction, delta)

func walk(direction : Vector2, delta : float):
	direction = direction.normalized()
	
	var current_stats := entity.stats.current_stats
	
	if entity.velocity.length() > current_stats.walking_speed:
		entity.velocity = entity.velocity.normalized() * (entity.velocity.length() - current_stats.hight_force_deceleration * delta)
	else:
		if direction == Vector2.ZERO:
			entity.velocity = entity.velocity.move_toward(Vector2.ZERO, delta * current_stats.walking_speed / current_stats.walking_deceleration)
		else:
			entity.velocity = entity.velocity.move_toward(direction * current_stats.walking_speed, delta * current_stats.walking_speed / current_stats.walking_acceleration)
			if reset_velocity_when_moving_in_opposite_direction:
				if direction.x != 0 && sign(direction.x) != sign(entity.velocity.x):
					entity.velocity.x = 0
				if direction.y != 0 && sign(direction.y) != sign(entity.velocity.y):
					entity.velocity.y = 0
