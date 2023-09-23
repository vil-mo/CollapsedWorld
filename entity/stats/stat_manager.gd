extends Object
class_name StatManager

var base_stats : StatList
var current_stats : StatList:
	get:
		for property in property_list:
			var linear = 0.0
			var scalar = 1.0
			for l in linear_buffs:
				linear += l.get(property)
			for s in scalar_buffs:
				scalar += s.get(property)
			
			current_stats.set(property, base_stats.get(property) * scalar + linear)
		
		return current_stats

var property_list : Array[String]

var scalar_buffs : Array[StatList] = []
var linear_buffs : Array[StatList] = []

func _init(my_stats : StatList) -> void:
	base_stats = my_stats
	current_stats = my_stats.duplicate()
	var script_properties = current_stats.get_script().get_script_property_list()
	for property in script_properties:
		if property['usage'] & PROPERTY_USAGE_SCRIPT_VARIABLE && (property['type'] == TYPE_INT || property['type'] == TYPE_FLOAT):
			property_list.append(property['name'])

func add_buff(scalar : StatList, linear : StatList = null):
	if linear:
		linear_buffs.append(linear)
	if scalar:
		scalar_buffs.append(scalar)


func remove_buff(buff : StatList):
	if buff in scalar_buffs:
		scalar_buffs.erase(buff)
	if buff in linear_buffs:
		linear_buffs.erase(buff)

