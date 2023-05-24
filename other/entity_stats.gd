extends Stats
class_name EntityStats

var current_stats : Stats

var scalar_buffs : Array[Stats] = []
var linear_buffs : Array[Stats] = []

func _init() -> void:
	current_stats = self as Stats

func add_buff(linear : Stats, scalar : Stats):
	if linear:
		linear_buffs.append(linear)
	if scalar:
		scalar_buffs.append(scalar)

func add_buff_for_seconds(linear : Stats, scalar : Stats, time : float):
	add_buff(linear, scalar)
	await GameManager.get_tree().create_timer(time).timeout
	remove_buff(linear)
	remove_buff(scalar)

func remove_buff(buff : Stats):
	if buff in scalar_buffs:
		scalar_buffs.erase(buff)
	if buff in linear_buffs:
		linear_buffs.erase(buff)

func update_current_stats():
	for property in STAT_PROPERTIES.values():
		var linear = 0
		var scalar = 0
		for l in linear:
			linear += l.get(property)
		for s in scalar:
			scalar += s.get(property)
		
		current_stats.set(property, get(property) * scalar + linear)
		
