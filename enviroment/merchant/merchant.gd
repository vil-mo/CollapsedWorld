extends Node2D
class_name Merchant

var merchant_resource : MerchantResource

@onready var sprite : Sprite2D = $Sprite2D

func _ready() -> void:
	EventBus.player_beat_room.connect(on_player_beat_room)

func initialize(to_merchant_resourse : MerchantResource) -> void:
	merchant_resource = to_merchant_resourse
	sprite.texture = merchant_resource.sprite
	close()

func on_player_beat_room():
	open()

func open():
	sprite.frame_coords.y = 0

func close():
	sprite.frame_coords.y = 1

