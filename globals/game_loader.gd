extends Node

var item_keys := {}

var item_recipes : Array[Recipe] = []

func _init():
	initialize_item_keys("res://items/")
	initialize_item_recipes()

func initialize_item_keys(in_directory : String):
	var dir = DirAccess.open(in_directory)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif dir.current_is_dir():
			initialize_item_keys(in_directory + file + "/")
		elif file.ends_with(".tres"):
			var loaded_file = load(in_directory + file)
			if loaded_file is ItemKey:
				assert(! item_keys.has(loaded_file.key), 'Item with key "' + loaded_file.key + '" already exists, file: ' + file)
				item_keys[loaded_file.key] = loaded_file
	
	dir.list_dir_end()

func initialize_item_recipes():
	for key in item_keys:
		var item : ItemKey = item_keys[key]
		for recipe in item.recipes:
			item_recipes.append(recipe)
			recipe.result = item
			recipe.progression_point = item.progression_point
			
	item_recipes.sort_custom(func(a, b): return a.progression_point > b.progression_point)
