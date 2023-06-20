extends Node2D
class_name StateMachine

@export var first_state : State

@onready var entity : Entity = owner

var current_state : State

func _ready() -> void:
	assert(first_state != null, "Forgot to set first state in %s" %entity.name)
	
	current_state = first_state
	
	for state in get_children():
		if state is State:
			state.entity = entity
			state.ready_state()

func _physics_process(delta: float) -> void:
	current_state.physics_process_state(delta)
	var transtition := current_state.check_if_should_transition()
	if transtition:
		_change_state(transtition.transition_to, transtition.transition_details)

func _process(delta: float) -> void:
	current_state.process_state(delta)

func _change_state(to : State, transition_details : Dictionary):
	current_state.exit(transition_details)
	current_state = to
	to.enter(transition_details)
