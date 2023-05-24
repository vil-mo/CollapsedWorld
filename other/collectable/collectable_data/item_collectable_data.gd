extends CollectableData
class_name ItemCollectableData

@export var item_key : ItemKey

@export var min_amount : int = 1
@export var max_amount : int = -1

func collect(player : PlayableCharacter):
	var amount = min_amount
	if max_amount > min_amount:
		amount = randi_range(min_amount, max_amount)
	player.inventory.add_item(item_key, amount)
