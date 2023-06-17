extends Node2D
class_name Merchant

var merchant_resource : MerchantResource

@onready var sprite : Sprite2D = $Sprite2D
@onready var player_detector : Area2D = $PlayerDetector

var opened := false

func _ready() -> void:
	EventBus.player_beat_room.connect(on_player_beat_room)
	player_detector.body_entered.connect(_on_player_entered_player_detector)
	player_detector.body_exited.connect(_on_player_exited_player_detector)

func initialize(to_merchant_resourse : MerchantResource) -> void:
	merchant_resource = to_merchant_resourse
	sprite.texture = merchant_resource.sprite
	close()
	
	EventBus.merchant_initialized.emit(merchant_resource)

func _on_player_entered_player_detector(player):
	EventBus.merchant_player_entered_detector.emit()

func _on_player_exited_player_detector(player):
	EventBus.merchant_player_exited_detector.emit()

func on_player_beat_room():
	open()

func open():
	sprite.frame_coords.y = 0
	opened = true
	player_detector.monitoring = true

func close():
	sprite.frame_coords.y = 1
	opened = false
	player_detector.monitoring = false

