extends CharacterBody2D
class_name Projectile

@export_flags("Player", "Enemy", "Enviroment") var targeting : int

var direction := Vector2.UP
var emitter : Entity

func _physics_process(delta: float) -> void:
	pass

func hitted_entity(enttiy : Entity):
	pass
