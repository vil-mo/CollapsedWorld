extends Status
class_name Equipment

@export var this_item_use_acitons : Array[String]

func action_used(action : String):
	if action in this_item_use_acitons:
		item_used()

func item_used():
	pass
