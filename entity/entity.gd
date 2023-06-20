extends CharacterBody2D
class_name Entity

@export var fall_texture : Texture2D
@export var drop_effect : PackedScene
@export var stats : EntityStats
@export_flags("Player", "Enemy", "Enviroment") var alignments : int
@export var able_to_fall := true

@onready var sprites : Node2D = $Visuals/Sprites
@onready var hitbox : Area2D = $Hitbox
@onready var ground_detector : Area2D = $GroundDetector
@onready var equipment_mahcine : StatusMachine = $EqupmentMachine


var is_on_ground := true
var is_fell := true
const FallAnimationScene = preload("res://entity/fall_animation.tscn")

func _enter_tree() -> void:
	is_fell = false
	velocity = Vector2.ZERO
	is_on_ground = true
	if sprites:
		sprites.material.set_shader_parameter("flash_amount", 0)

func _ready() -> void:
	pass

func _physics_process(delta):
	move_and_slide()
	_check_ground()
	stats.update_current_stats()

# TODO: fix this piece of garbage checking somehow
func _check_ground():
	if len(ground_detector.get_overlapping_bodies()) == 0 && is_on_ground:
		await get_tree().physics_frame
	
	if len(ground_detector.get_overlapping_bodies()) == 0 && is_on_ground:
		is_on_ground = false
		if able_to_fall:
			fall()
	elif len(ground_detector.get_overlapping_bodies()) > 0 && !is_on_ground:
		is_on_ground = true


func equip(equipment : Status):
	equipment_mahcine.equip(equipment)

func unequip(equipmunt : Status):
	equipment_mahcine.unequip(equipmunt)

func handle_attack(attack : Attack):
	_apply_knockback(attack.get_knockback_vector(self))
	_apply_iframes(attack.iframes_duration)

func _apply_knockback(force : Vector2):
	force *= 1 - stats.current_stats.knockback_resist
	velocity += force

func _apply_iframes(iframes_duration : float):
	_flash_sprite(iframes_duration)
	_disable_hitbox(iframes_duration)
	
func _disable_hitbox(duration : float):
	hitbox.monitorable = false
	hitbox.monitoring = false
	await get_tree().create_timer(duration).timeout
	hitbox.monitorable = true
	hitbox.monitoring = true

func _flash_sprite(duration : float):
	sprites.material.set_shader_parameter("flash_amount", 0.99)
	await get_tree().create_timer(duration * 0.8).timeout
	if is_inside_tree():
		create_tween()\
		.tween_property(sprites, "material:shader_parameter/flash_amount", 0, duration * 0.2)


func fall():
	is_fell = true
	
	var fall_animation : Sprite2D = FallAnimationScene.instantiate()
	fall_animation.set_velocity(velocity)
	fall_animation.texture = fall_texture
	fall_animation.global_position = global_position
	add_sibling(fall_animation)
	
	_deal_fall_damage()
	
	FallenEntitiesManager.entity_fell(self)

func _deal_fall_damage():
	pass
