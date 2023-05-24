extends Area2D

@export var collectable_data : CollectableData
@export var attract_to_player := true
@export var speed_of_attraction := 100

@onready var sprite : Sprite2D = $Visuals/Sprite2D
@onready var animation_player : AnimationPlayer = $Visuals/AnimationPlayer

func _ready() -> void:
	if collectable_data is ItemCollectableData:
		sprite.texture = collectable_data.item_key.grounded_sprite

func _physics_process(delta: float) -> void:
	if attract_to_player && ! GameManager.player.is_fell:
		global_position += global_position.direction_to(GameManager.player.global_position) * speed_of_attraction * delta

func collect(player : PlayableCharacter):
	collectable_data.collect(player)
	animation_player.play("collected")
