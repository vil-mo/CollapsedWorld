extends Node2D
class_name StateTransition

@export var transition_to : State
@export var transition_details : Dictionary = {}

# If returns true, trying to transition
func check_transition() -> bool:
	return false
