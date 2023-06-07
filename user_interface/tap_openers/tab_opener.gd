extends Control
class_name TabOpener

@export var can_be_opened := true:
	set(val):
		can_be_opened = val
		if val && !EventBus.ui_open_inventory.is_connected(open):
			EventBus.ui_open_inventory.connect(open)
		elif !val && EventBus.ui_open_inventory.is_connected(open):
			EventBus.ui_open_inventory.disconnect(open)

@export var open_position := Vector2(0, 38)
@export var close_position := Vector2(-270, 38)

@onready var panel : Control = $Panel

var is_open := false

func _ready() -> void:
	EventBus.ui_close_inventory.connect(close)
	can_be_opened = can_be_opened

func open():
	if !is_open:
		is_open = true
		
		panel.position = close_position
		var tween : Tween = create_tween()
		tween.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)\
		.tween_property(panel, "position", open_position, 0.9)

func close():
	if is_open:
		is_open = false
		
		panel.position = open_position
		var tween : Tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)\
		.tween_property(panel, "position", close_position, 0.4)
