extends Stats
class_name EntityStats

var current_stats : Stats

var scalar_buffs : Array[Stats] = []
var linear_buffs : Array[Stats] = []

func _init() -> void:
	current_stats = Stats.new()

func add_buff(linear : Stats, scalar : Stats):
	if linear:
		linear_buffs.append(linear)
	if scalar:
		scalar_buffs.append(scalar)
	

func remove_buff(buff : Stats):
	if buff in scalar_buffs:
		scalar_buffs.erase(buff)
	if buff in linear_buffs:
		linear_buffs.erase(buff)

func update_current_stats():
	for property in STAT_PROPERTIES.values():
		var linear = 0
		var scalar = 1
		for l in linear_buffs:
			linear += l.get(property)
		for s in scalar_buffs:
			scalar += s.get(property)
		
		current_stats.set(property, get(property) * scalar + linear)
	

