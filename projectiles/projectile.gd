extends CharacterBody2D
class_name Projectile

@export_flags("Player", "Enemy", "Enviroment") var targeting : int

@onready var hurtboxes : Array[Node] = $Hurtboxes.get_children()
@onready var hitbox : Area2D = $Hitbox

var direction := Vector2.UP
var emitter : Entity

func _physics_process(delta: float) -> void:
	for hurtbox in hurtboxes:
		for entity_hitbox in hurtbox.get_overlapping_areas():
			var entity : Entity = entity_hitbox.owner
			if hurtbox.can_hit_entity(entity) && (targeting & entity.alignments):
				entity.handle_attack(hurtbox.get_attack_for_entity(entity))
				hurtbox.append_to_already_hitted(entity)
