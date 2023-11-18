extends CharacterBody2D
class_name Entity

enum ALIGNMENT_NAME {PLAYER, ENEMY, ENVIROMENT}
const ALIGNMENTS := {ALIGNMENT_NAME.PLAYER : 0b1, ALIGNMENT_NAME.ENEMY : 0b10, ALIGNMENT_NAME.ENVIROMENT : 0b100}
@export_flags("Player", "Enemy", "Environment") var my_alignments : int

var emitter : Entity = null

@onready var status_mahcine : StatusMachine = $StatusMachine
var before_applying_impact := {} # For detecting initial information, not changing state of impact
var applying_impact := {}        # For changing state of impact
var after_applying_impact := {}  # For detecting changes
# T : Impact, {T : fun(T)}

func _enter_tree() -> void:
	velocity = Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(delta):
	move_and_slide()

func apply_status(status : PackedScene) -> Status:
	var status_instance : Status = status.instantiate()
	status_mahcine.apply(status_instance)
	return status_instance

func apply_impact(_impact : Impact):
	var impact : Impact = _impact.duplicate()
	var impact_script : Script = impact.get_script()
	for status in status_mahcine.statuses:
		if status.before_applying_impact.has(impact_script):
			status.before_applying_impact[impact_script].call(impact)
	if before_applying_impact.has(impact_script):
		before_applying_impact[impact_script].call(impact)
	
	for status in status_mahcine.statuses:
		if status.applying_impact.has(impact_script):
			status.applying_impact[impact_script].call(impact)
	if applying_impact.has(impact_script):
		applying_impact[impact_script].call(impact)
	
	impact.apply(self)
	
	for status in status_mahcine.statuses:
		if status.after_applying_impact.has(impact_script):
			status.after_applying_impact[impact_script].call(impact)
	if after_applying_impact.has(impact_script):
		after_applying_impact[impact_script].call(impact)

func remove_status(status : Status):
	status_mahcine.remove(status)
	status.queue_free()

func change_alignments(to : int):
	my_alignments = to

func emit_projectile(projectile : PackedScene, replace_emitter : bool, as_child := false) -> Entity:
	var proj_instance : Entity = projectile.instantiate()
	if replace_emitter:
		proj_instance.emitter = self
	else:
		proj_instance.emitter = emitter
	
	proj_instance.global_position = global_position
	
	if as_child:
		proj_instance.emitter.add_child(proj_instance)
	else:
		proj_instance.emitter.add_sibling(proj_instance)
	
	return proj_instance
