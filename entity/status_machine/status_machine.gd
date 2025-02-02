extends Node2D
class_name StatusMachine

@onready var statuses : Array[Status]

func _ready() -> void:
	for c in get_children():
		statuses.append(c)

func apply(satus : Status):
	satus.entity = owner
	add_child(satus)
	satus.applyed()
	statuses.append(satus)

func remove(satus : Status):
	satus.removed()
	remove_child(satus)
	statuses.erase(satus)

func use_action(action : String, continuous_use : bool = false):
	for status in statuses:
		if status.usable:
			status.action_used(action)
			if continuous_use && !status.continuously_used:
				status.started_using_action(action)

func stop_using_action(action : String):
	for status in statuses:
		if status.usable && status.continuously_used:
			status.stopped_using_action(action)


func get_status_with_script(script : Script) -> Status:
	for status in statuses:
		if status.get_script() == script:
			return status
	
	return null

func get_status_of_class(script : Script) -> Status:
	for status in statuses:
		if is_instance_of(status, script):
			return status
	
	return null

func get_statuses_of_class(script : Script) -> Array[Status]:
	var output : Array[Status] = []
	for status in statuses:
		if is_instance_of(status, script):
			output.append(status)
	
	return output
