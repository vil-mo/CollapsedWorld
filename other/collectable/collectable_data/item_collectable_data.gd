extends CollectableData
class_name ItemCollectableData

@export var item_key : ItemKey

@export var min_amount : int = 1
@export var max_amount : int = -1

func collect(player : Player):
	var amount = min_amount
	if max_amount > min_amount:
		amount = randi_range(min_amount, max_amount)
	EventBus.inventory_add_item.emit(item_key, amount)
