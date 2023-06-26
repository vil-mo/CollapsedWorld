extends Entity
class_name Fighter

@export var stat_list : FighterStats

@export var drop_effect : PackedScene
@export var fall_texture : Texture2D
@export var able_to_fall := true

@onready var ground_detector : Area2D = $GroundDetector
@onready var flashing_on_damage_sprites : Node2D = $Visuals/FlashingOnDamageSprites

var is_on_ground := true
var is_fell := true
const FallAnimationScene = preload("res://entity/fall_animation.tscn")

@onready var stats : StatManager = StatManager.new(stat_list)

func _enter_tree() -> void:
	super()
	is_fell = false
	is_on_ground = true
	if flashing_on_damage_sprites:
		flashing_on_damage_sprites.material.set_shader_parameter("flash_amount", 0)

func _physics_process(delta: float) -> void:
	super(delta)
	_check_ground()

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



func _apply_knockback(force : Vector2):
	force *= 1 - stats.current_stats.knockback_resist
	velocity += force

func _apply_iframes(iframes_duration : float):
	_flash_sprite(iframes_duration)
	#_disable_hitbox(iframes_duration)

func _flash_sprite(duration : float):
	flashing_on_damage_sprites.material.set_shader_parameter("flash_amount", 0.99)
	await get_tree().create_timer(duration * 0.8).timeout
	if is_inside_tree():
		create_tween()\
		.tween_property(flashing_on_damage_sprites, "material:shader_parameter/flash_amount", 0, duration * 0.2)

func fall():
	is_fell = true
	
	var fall_animation : Sprite2D = FallAnimationScene.instantiate()
	fall_animation.set_velocity(velocity)
	fall_animation.texture = fall_texture
	fall_animation.global_position = global_position
	add_sibling(fall_animation)
	
	FallenEntitiesManager.entity_fell(self)
