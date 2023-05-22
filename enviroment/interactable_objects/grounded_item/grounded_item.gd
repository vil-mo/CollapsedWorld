extends InteractableArea

@export var item_key_string = "shadow_sword"
@onready var item_key = GameManager.ITEMS_KEY_INFORMATION[item_key_string]

func _ready():
	$Visuals/Sprite2D.texture = item_key.grounded_sprite

func set_item_key(val):
	if val is String:
		item_key_string = val
		item_key = GameManager.ITEMS_KEY_INFORMATION[item_key_string]
	else:
		item_key = val
		item_key_string = item_key.key
	$Visuals/Sprite2D.texture = item_key.grounded_sprite

func interact(player: Player):
	player.pick_up_grounded_item(self)
	queue_free()
