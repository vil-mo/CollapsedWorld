extends CharacterBody2D
class_name Entity

@export var fall_texture : Texture2D
@export var drop_effect : PackedScene

@export_group("Combat")
@export var stats : EntityStats
@export_flags("Player", "Enemy", "Enviroment") var alignments : int

@export_group("Flags")
@export var reset_velocity_when_moving_in_opposite_direction := true
@export var able_to_fall := true

@onready var sprite : Node2D = $Visuals/Sprite
@onready var hitbox : Area2D = $Hitbox
@onready var ground_detector : Area2D = $GroundDetector

var is_on_ground := true
var is_fell := true

const FallAnimationScene = preload("res://entity/fall_animation.tscn")

func _enter_tree() -> void:
	velocity = Vector2.ZERO
	is_on_ground = true
	got_on_ground()
	if sprite:
		sprite.material.set_shader_parameter("flash_amount", 0)

func _ready() -> void:
	pass

func _physics_process(delta):
	move_and_slide()
	check_ground()

func check_ground():
	if len(ground_detector.get_overlapping_bodies()) == 0 && is_on_ground:
		await get_tree().physics_frame
	
	if len(ground_detector.get_overlapping_bodies()) == 0 && is_on_ground:
		is_on_ground = false
		got_off_ground()
		if able_to_fall:
			fall()
	elif len(ground_detector.get_overlapping_bodies()) > 0 && !is_on_ground:
		is_on_ground = true
		got_on_ground()


func walk(direction : Vector2, delta : float):
	direction = direction.normalized()
	
	if velocity.length() > stats.current_stats.walking_speed:
		velocity = velocity.normalized() * (velocity.length() - stats.current_stats.hight_force_deceleration * delta)
	else:
		if direction == Vector2.ZERO:
			velocity = velocity.move_toward(Vector2.ZERO, delta * stats.current_stats.walking_speed / stats.current_stats.walking_deceleration)
		else:
			velocity = velocity.move_toward(direction * stats.current_stats.walking_speed, delta * stats.current_stats.walking_speed / stats.current_stats.walking_acceleration)
			if reset_velocity_when_moving_in_opposite_direction:
				if direction.x != 0 && sign(direction.x) != sign(velocity.x):
					velocity.x = 0
				if direction.y != 0 && sign(direction.y) != sign(velocity.y):
					velocity.y = 0

func got_on_ground():
	pass
func got_off_ground():
	pass

func apply_knockback(force : Vector2):
	force *= 1 - stats.current_stats.knockback_resist
	velocity += force

func disable_hitbox(duration : float):
	hitbox.monitorable = false
	hitbox.monitoring = false
	await get_tree().create_timer(duration).timeout
	hitbox.monitorable = true
	hitbox.monitoring = true

func flash_sprite(duration : float):
	sprite.material.set_shader_parameter("flash_amount", 0.99)
	await get_tree().create_timer(duration * 0.8).timeout
	if is_inside_tree():
		create_tween()\
		.tween_property(sprite, "material:shader_parameter/flash_amount", 0, duration * 0.2)

func handle_attack(attack : Attack):
	var knockback = attack.get_knockback_vector(self)
	apply_knockback(knockback)
	if attack.should_flash:
		flash_sprite(attack.hit_invulnurability_duration)
	disable_hitbox(attack.hit_invulnurability_duration)

func deal_fall_damage():
	pass

func fall():
	is_fell = true
	
	var fall_animation : Sprite2D = FallAnimationScene.instantiate()
	fall_animation.set_velocity(velocity)
	fall_animation.texture = fall_texture
	fall_animation.global_position = global_position
	add_sibling(fall_animation)
	
	FallenEntitiesManager.entity_fell(self)

