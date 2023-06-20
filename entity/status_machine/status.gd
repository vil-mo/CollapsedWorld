extends Node2D
class_name Status

@export var scalar_buff : Stats
@export var linear_buff : Stats
@export var actions : Array[String] = []
@export var usable := true

var entity : Entity

func equiped():
	entity.stats.add_buff(linear_buff, scalar_buff)

func unequiped():
	entity.stats.remove_buff(linear_buff)
	entity.stats.remove_buff(scalar_buff)

func use(_by_action : String):
	pass
