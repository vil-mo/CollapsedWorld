extends Area2D
class_name InteractableArea

@onready var sprite = $Visuals/Sprite2D

func interact(interacter):
	print("interacted")
