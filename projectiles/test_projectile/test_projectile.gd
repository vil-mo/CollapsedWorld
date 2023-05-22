extends Projectile

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	super(delta)
	global_position.x += 150 * delta
