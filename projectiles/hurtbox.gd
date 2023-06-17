extends Area2D
class_name Hurtbox

@export var attack : Attack
@export var time_before_can_hit_entity_again : float = 0.1

var already_hitted_entities : Array[Entity] = []

func _ready() -> void:
	attack.projectile = owner
	attack.emitter = owner.emitter

func _physics_process(delta: float) -> void:
	for entity_hitbox in get_overlapping_areas():
		var entity : Entity = entity_hitbox.owner
		if can_hit_entity(entity) && (owner.targeting & entity.alignments):
			owner.hitted_entity(entity)
			entity.handle_attack(get_attack_for_entity(entity))
			append_to_already_hitted(entity)

func can_hit_entity(entity : Entity) -> bool:
	return !already_hitted_entities.has(entity)

func get_attack_for_entity(entity : Entity) -> Attack:
	return attack

func append_to_already_hitted(entity : Entity) -> void:
	already_hitted_entities.append(entity)
	await get_tree().create_timer(time_before_can_hit_entity_again).timeout
	already_hitted_entities.erase(entity)




