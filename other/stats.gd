extends Resource
class_name Stats

const STAT_PROPERTIES = {
	walking_speed = "walking_speed",
	walking_acceleration = "walking_acceleration",
	walking_deceleration = "walking_deceleration",
	hight_force_deceleration = "hight_force_deceleration",
	knockback_resist = "knockback_resist",
	fall_damage = "fall_damage",
}

@export_group("Velocity")
@export var walking_speed : float = 0
@export var walking_acceleration : float = 0
@export var walking_deceleration : float = 0
@export var hight_force_deceleration : float = 0

@export_group("Combat")
@export var knockback_resist : float = 0

@export var fall_damage : int = 0

