extends Node2D
class_name State

var transitions : Array[StateTransition]

func _ready() -> void:
	for transition in get_children():
		if transition is StateTransition:
			transitions.append(transition)

func check_if_should_transition() -> StateTransition:
	for transition in transitions:
		if transition.check_transition():
			return transition
	return null

func ready_state(entity : Entity):
	pass

func physics_process_state(entity : Entity, delta : float):
	pass

func process_state(entity : Entity, delta : float):
	pass

func enter(entity : Entity, transition_details : Dictionary):
	pass

func exit(entity : Entity, transition_details : Dictionary):
	pass
