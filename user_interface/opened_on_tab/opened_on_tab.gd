extends Control
class_name OpenedOnTab

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

@onready var tween : Tween

func _ready() -> void:
	EventBus.ui_close_inventory.connect(close)
	can_be_opened = can_be_opened


func open():
	if !is_open:
		if tween && tween.is_valid():
			tween.kill()
		
		is_open = true
		
		tween = create_tween()
		tween.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)\
		.tween_property(panel, "position", open_position, randf_range(0.8, 1))

func close():
	if is_open:
		if tween && tween.is_valid():
			tween.kill()
		
		is_open = false
		
		tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)\
		.tween_property(panel, "position", close_position, 0.4)
