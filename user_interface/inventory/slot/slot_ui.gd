extends TextureRect
class_name SlotUI

@export var deafult_icon : Texture2D
@export var show_item_amount := true

@onready var icon : TextureRect = $Icon
@onready var amount_label : Label = $Amount

var stored_item : ItemKey = null

func _ready():
	icon.texture = deafult_icon

func _physics_process(delta: float) -> void:
	if stored_item && stored_item.amount > 1:
		amount_label.visible = true
		amount_label.text = str(stored_item.amount)
	else:
		amount_label.visible = false

func store_item(item_key):
	icon.texture = item_key.icon
	stored_item = item_key

func remove_item():
	stored_item = null
	icon.texture = deafult_icon
