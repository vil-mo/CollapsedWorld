extends VBoxContainer

@onready var slot = $SlotUI
@onready var amount_label = $Amount

var item : ItemKey
var should_be_amount : int

func initialize(init_item : ItemKey, init_should_be_amount : int):
	item = init_item
	should_be_amount = init_should_be_amount
	slot.store_item(item)

func _physics_process(delta: float) -> void:
	if item:
		slot.set_interacted_color(item.amount < should_be_amount)
		amount_label.text = str(item.amount) + "/" + str(should_be_amount) 
