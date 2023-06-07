extends HBoxContainer

@export var stored_currency : ItemKey

@onready var icon := $Icon
@onready var label := $Label

func _ready() -> void:
	assert(stored_currency.item_type == ItemKey.ITEM_TYPE.CURRENCY, "In %s. Stored item is not currency" %name)
	
	icon.texture = stored_currency.icon

func _physics_process(delta: float) -> void:
	label.text = str(stored_currency.amount)
