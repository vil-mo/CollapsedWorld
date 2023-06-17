extends Resource
class_name Recipe

@export var amount_crafted : int = 1
@export var ingridients : Dictionary

var result : ItemKey
var progression_point : float
var biome_flags : int

var has_some_ingridients := true
var can_be_crafted := false

func _init() -> void:
	EventBus.inventory_item_amount_changed.connect(on_item_amount_changed)

func on_item_amount_changed(item_key : ItemKey):
	if item_key in ingridients:
		has_some_ingridients = false
		can_be_crafted = true
		for key in ingridients:
			if key.amount != 0:
				has_some_ingridients = true
			if key.amount < ingridients[key]:
				can_be_crafted = false
		

