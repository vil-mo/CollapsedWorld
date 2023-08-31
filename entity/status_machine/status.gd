extends Node2D
class_name Status

@export var usable := true

var before_applying_impact := {} # For detecting initial information, not changing state of impact
var applying_impact := {}        # For changing state of impact
var after_applying_impact := {}  # For detecting changes

var entity : Entity

func applyed():
	pass

func removed():
	pass

func action_used(action : String):
	pass



func remove():
	entity.remove_status(self)
