extends TileMap
class_name RoomGeneration

const BASE_LAYER = 0
const GROUND_LAYER = 1
const WALL_LAYER = 2

const BASE_ATLAS = 0
const USED_TERRAIN_SET = 0
const GROUND_TERRAIN = 0
const WALL_TERRAIN = 1

const BIOME_TILES_SOURSE_ID = 1

const GROUND_NAVIGATION_LAYER = 0

const tiles := {
	empty = Vector2i(0, 0),
	ground = Vector2i(1, 0),
	wall = Vector2i(2, 0),
	merchant = Vector2i(3, 0),
	door_bottom = Vector2i(4, 0),
	door_left = Vector2i(5, 0),
	door_right = Vector2i(6, 0),
	
}
const SIDES_AND_CORNERS : Array[int] = [
	TileSet.CELL_NEIGHBOR_RIGHT_SIDE, 
	TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER,
	TileSet.CELL_NEIGHBOR_BOTTOM_SIDE, 
	TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
	TileSet.CELL_NEIGHBOR_LEFT_SIDE, 
	TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER,
	TileSet.CELL_NEIGHBOR_TOP_SIDE, 
	TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER,
]
const SIDES : Array[int] = [
	TileSet.CELL_NEIGHBOR_RIGHT_SIDE, 
	TileSet.CELL_NEIGHBOR_BOTTOM_SIDE, 
	TileSet.CELL_NEIGHBOR_LEFT_SIDE, 
	TileSet.CELL_NEIGHBOR_TOP_SIDE, 
]

const DoorScene = preload("res://enviroment/door/door.tscn")
const MerchantScene = preload("res://enviroment/merchant/merchant.tscn")
var generated_objects : Array[Node] = []
var room_generated : bool = false

func remove_room():
	if room_generated:
		for door in generated_objects:
			door.queue_free()
		generated_objects.clear()
		clear()
		room_generated = false

func generate_room(generation_conditions : GenerationConditions):
	
	# Initializing ============================================================
	if room_generated:
		remove_room()
	
	tile_set.get_source(BIOME_TILES_SOURSE_ID).texture = generation_conditions.get_tile_texture()
	
	# Filling all up ========================================================
	for x in range(-5, generation_conditions.size.x + 5):
		for y in range(-5, generation_conditions.size.y + 5):
			set_cell(BASE_LAYER, Vector2i(x, y), BASE_ATLAS, tiles.empty)
	
	for x in generation_conditions.size.x:
		for y in generation_conditions.size.y:
			set_cell(BASE_LAYER, Vector2i(x, y), BASE_ATLAS, tiles.ground)
	
	
	# Making holes ==================================================
	
	var ground_cells := get_used_cells_by_id(BASE_LAYER, -1, tiles.ground)
	for i in generation_conditions.holes_amount:
		set_cell(BASE_LAYER, ground_cells.pick_random(), BASE_ATLAS, tiles.empty)
	
	#Removing tiles at edges randomly
	
	for i in generation_conditions.initial_ground_removing_amount:
		
		ground_cells = get_used_cells_by_id(BASE_LAYER, -1, tiles.ground)
		
		var to_remove_coords : Array[Vector2i] = []
		
		for cell in ground_cells:
			var sides_maching : Array[Vector2i] = get_neighbors_of_atlas(BASE_LAYER, cell, [tiles.empty], SIDES_AND_CORNERS)
			if randf() < sides_maching.size() * generation_conditions.initial_ground_chance_to_be_removed:
				to_remove_coords.append(cell)
		
		for coord in to_remove_coords:
			set_cell(BASE_LAYER, coord, BASE_ATLAS, tiles.empty)
	
	# Cleaning ======================================
	clean_up()
	
	
	# Walls instantiating ====================================
	ground_cells = get_used_cells_by_id(BASE_LAYER, -1, tiles.ground)

	for i in generation_conditions.walls_amount:
		var current_wall = ground_cells.pick_random()
		set_cell(BASE_LAYER, current_wall, BASE_ATLAS, tiles.wall)
		for j in generation_conditions.walls_neghbor_amount - 1:
			var random_neighbor := get_neighbor_cell(current_wall, SIDES_AND_CORNERS.pick_random())
			if tiles.ground == get_cell_atlas_coords(BASE_LAYER, random_neighbor):
				current_wall = random_neighbor
				set_cell(BASE_LAYER, current_wall, BASE_ATLAS, tiles.wall)
	
	# Expanding walls ====================================
	for i in generation_conditions.walls_expanding_amount:
		
		ground_cells = get_used_cells_by_id(BASE_LAYER, -1, tiles.ground)
		
		var to_expand_coords : Array[Vector2i] = []
		
		for cell in ground_cells:
			var wall_neighbors := get_neighbors_of_atlas(BASE_LAYER, cell, [tiles.wall], SIDES_AND_CORNERS)
			
			if randf() < wall_neighbors.size() * generation_conditions.walls_chance_to_be_expanded:
				to_expand_coords.append(cell)
		for coord in to_expand_coords:
			set_cell(BASE_LAYER, coord, BASE_ATLAS, tiles.wall)
	
	
	# Cleaning walls ====================================
	ground_cells = get_used_cells_by_id(BASE_LAYER, -1, tiles.ground)
	
	for cell in ground_cells:
		var wall_neighbors : Array[Vector2i] =  get_neighbors_of_atlas(BASE_LAYER, cell, [tiles.wall], SIDES)
		
		if wall_neighbors.size() >= 2:
			set_cell(BASE_LAYER, cell, BASE_ATLAS, tiles.wall)
	
	
	# Filling up ground so that walls not near the empty ======================================
	
	var used_cells = get_used_cells(BASE_LAYER)
	var last_atlas = get_atlas_of_cells(BASE_LAYER, used_cells)
	
	while true:
		ground_cells = get_used_cells_by_id(BASE_LAYER, -1, tiles.ground)
		
		for cell in ground_cells:
			var wall_neighbors = get_neighbors_of_atlas(BASE_LAYER, cell, [tiles.wall], SIDES_AND_CORNERS)
			if wall_neighbors.size() > 0:
				for empty in get_neighbors_of_atlas(BASE_LAYER, cell, [tiles.empty], SIDES_AND_CORNERS):
					set_cell(BASE_LAYER, empty, BASE_ATLAS, tiles.ground)
		
		var current_atlas := get_atlas_of_cells(BASE_LAYER, used_cells)
		if current_atlas == last_atlas:
			break
		last_atlas = current_atlas
	
	
	# Connecting land =======================================================
	
	if generation_conditions.should_connect_land:
		var land : Array[Array] = get_land(BASE_LAYER, [tiles.ground])
		
		land.shuffle()
		
		for i in land.size() - 1:
			var land1 = land[i]
			var land2 = land[i + 1]
			var closest := find_closest_point_between_two_arrays(land1, land2)
			
			for cell in get_used_cells_by_id(BASE_LAYER, -1, tiles.empty):
				var point := Geometry2D.get_closest_point_to_segment(cell, closest[0], closest[1])
				if point.distance_squared_to(cell) <= generation_conditions.connecting_land_connection_wideness:
					set_cell(BASE_LAYER, cell, BASE_ATLAS, tiles.ground)
	
	# Removing wall land =======================================================
	
	var wall_land := get_land(BASE_LAYER, [tiles.wall])
	var wall_and_ground_land := get_land(BASE_LAYER, [tiles.wall, tiles.ground])
	for l in wall_and_ground_land:
		for w in wall_land:
			if l == w:
				for cell in l:
					set_cell(BASE_LAYER, cell, BASE_ATLAS, tiles.empty)
	
	
	# Cleaning up again ==================================================
	clean_up()
	
	# Adding merchant
	
	if generation_conditions.merchant:
		const SIDES_OF_MERCHANT = {
			TileSet.CELL_NEIGHBOR_BOTTOM_SIDE : [
				TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
				TileSet.CELL_NEIGHBOR_BOTTOM_SIDE,
				TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER,
			],
		}
		place_progression_object(SIDES_OF_MERCHANT, {TileSet.CELL_NEIGHBOR_BOTTOM_SIDE : tiles.merchant})
	
	# Adding doors ==========================================================
	
	const SIDES_OF_DOOR = {
		TileSet.CELL_NEIGHBOR_BOTTOM_SIDE : [
			TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
			TileSet.CELL_NEIGHBOR_BOTTOM_SIDE,
			TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER,
		], 
		TileSet.CELL_NEIGHBOR_RIGHT_SIDE : [
			TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER,
			TileSet.CELL_NEIGHBOR_RIGHT_SIDE,
			TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER,
		],
		TileSet.CELL_NEIGHBOR_LEFT_SIDE : [
			TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
			TileSet.CELL_NEIGHBOR_LEFT_SIDE,
			TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER,
		],
	}
	for door in generation_conditions.doors_amount:
		place_progression_object(
			SIDES_OF_DOOR, 
			{
				TileSet.CELL_NEIGHBOR_BOTTOM_SIDE : tiles.door_bottom, 
				TileSet.CELL_NEIGHBOR_LEFT_SIDE : tiles.door_left, 
				TileSet.CELL_NEIGHBOR_RIGHT_SIDE : tiles.door_right, 
			}
		)
	
	# Intsantiating after generation ===========================================================
	
	ground_cells = get_used_cells_by_id(BASE_LAYER, -1, tiles.ground)
	var wall_cells = get_used_cells_by_id(BASE_LAYER, -1, tiles.wall)
	ground_cells.append_array(wall_cells)
	set_cells_terrain_connect(GROUND_LAYER, ground_cells, USED_TERRAIN_SET, GROUND_TERRAIN)
	set_cells_terrain_connect(WALL_LAYER, wall_cells, USED_TERRAIN_SET, WALL_TERRAIN)
	
	if generation_conditions.merchant:
		var merchant_cell = get_used_cells_by_id(BASE_LAYER, -1, tiles.merchant)[0]
		var merchant = MerchantScene.instantiate()
		generated_objects.append(merchant)
		add_child(merchant)
		merchant.position = map_to_local(merchant_cell)
		merchant.initialize(generation_conditions.merchant)
	
	var doors_bottom = get_used_cells_by_id(BASE_LAYER, -1, tiles.door_bottom)
	var doors_right = get_used_cells_by_id(BASE_LAYER, -1, tiles.door_right)
	var doors_left = get_used_cells_by_id(BASE_LAYER, -1, tiles.door_left)
	
	for cell in doors_bottom:
		var door = DoorScene.instantiate()
		generated_objects.append(door)
		add_child(door)
		door.position = map_to_local(cell)
		door.initialize(Vector2.DOWN, randi_range(0, 1))
	for cell in doors_right:
		var door = DoorScene.instantiate()
		generated_objects.append(door)
		add_child(door)
		door.position = map_to_local(cell)
		door.initialize(Vector2.RIGHT, randi_range(0, 1))
	for cell in doors_left:
		var door = DoorScene.instantiate()
		generated_objects.append(door)
		add_child(door)
		door.position = map_to_local(cell)
		door.initialize(Vector2.LEFT, randi_range(0, 1))
	
	# Finishing ===================================================================
	
	room_generated = true

func place_progression_object(
	all_sides : Dictionary, 
	tile : Dictionary, 
	next_to = [tiles.ground], 
	considering_for_all_neighbors = [
		tiles.ground, 
		tiles.wall, 
		tiles.merchant, 
		tiles.door_bottom,
		tiles.door_left, 
		tiles.door_right
	]
):
	
	var empty_cells = get_used_cells_by_id(BASE_LAYER, -1, tiles.empty)
	var empty_cells_that_have_sides_of_progression_object = []
	
	for cell in empty_cells:
		for current_sides_key in all_sides:
			var current_sides = all_sides[current_sides_key]
			var progression_object_sides_neighbors := get_neighbors_of_atlas(BASE_LAYER, cell, next_to, current_sides)
			var all_neighbors := get_neighbors_of_atlas(BASE_LAYER, cell, considering_for_all_neighbors, SIDES_AND_CORNERS)
			
			var arrays_match := true
			for n in all_neighbors:
				if ! n in progression_object_sides_neighbors:
					arrays_match = false
					break
			
			if progression_object_sides_neighbors.size() > 0 and arrays_match:
				progression_object_sides_neighbors.append(cell)
				empty_cells_that_have_sides_of_progression_object.append([progression_object_sides_neighbors, current_sides_key])
	
	empty_cells_that_have_sides_of_progression_object.sort_custom(func(a, b): return a[0].size() > b[0].size())
	
	var cell_to_put_progression_object_on = empty_cells_that_have_sides_of_progression_object[0][0]
	var current_side = empty_cells_that_have_sides_of_progression_object[0][1]
	if cell_to_put_progression_object_on.size() != all_sides[current_side].size() + 1:
		for side in all_sides[current_side]:
			var neighbor = get_neighbor_cell(cell_to_put_progression_object_on[-1], side)
			set_cell(BASE_LAYER, neighbor, BASE_ATLAS, tiles.ground)
	set_cell(BASE_LAYER, cell_to_put_progression_object_on[-1], BASE_ATLAS, tile[current_side])

func clean_up():
	const what_tile_becomes_if_too_many_sides := {
		tiles.empty : tiles.ground,
		tiles.ground : tiles.empty,
		tiles.wall : tiles.wall
	}
	
	var used_cells := get_used_cells(BASE_LAYER)
	var last_atlas := get_atlas_of_cells(BASE_LAYER, used_cells)
	
	for i in 10:
		var to_remove_coords : Array[Vector2i] = []
		
		for cell in used_cells:
			var atlas := get_cell_atlas_coords(BASE_LAYER, cell)
			var sides_maching : Array[Vector2i] = get_neighbors_of_atlas(BASE_LAYER, cell, [atlas], SIDES)
			
			if sides_maching.size() <= 1:
				to_remove_coords.append(cell)
		
		for coord in to_remove_coords:
			set_cell(BASE_LAYER, coord, BASE_ATLAS, what_tile_becomes_if_too_many_sides[get_cell_atlas_coords(BASE_LAYER, coord)])
		
		var current_atlas := get_atlas_of_cells(BASE_LAYER, used_cells)
		if current_atlas == last_atlas:
			break
		last_atlas = current_atlas

func get_land(layer : int, land_consists_of : Array[Vector2i]) -> Array[Array]:
	var cells : Array[Vector2i] = []
	for a in land_consists_of:
		cells.append_array(get_used_cells_by_id(layer, -1, a))
	
	var analized : Array[Vector2i] = []
	var land : Array[Array] = []
	
	for cell in cells:
		if !cell in analized:
			land.append([])
			finding_land_recurtion(cell, land, land_consists_of)
			analized.append_array(land[-1])
	
	return land

func finding_land_recurtion(cell : Vector2i, land : Array[Array], atlas : Array[Vector2i]):
	if !cell in land[-1]:
		land[-1].append(cell)
		var neighbors = get_neighbors_of_atlas(BASE_LAYER, cell, atlas, SIDES)
		for neighbor in neighbors:
			finding_land_recurtion(neighbor, land, atlas)

func find_closest_point_between_two_arrays(a1 : Array, a2 : Array) -> Array:
	var points : Array[Array] = []
	var min_dist : float = INF
	for p1 in a1:
		for p2 in a2:
			var dist := Vector2(p1).distance_squared_to(p2)
			if dist < min_dist:
				min_dist = dist
				points.clear()
				points.append([p1, p2])
			elif is_equal_approx(dist, min_dist):
				points.append([p1, p2])
	return points.pick_random()

func get_neighbors_of_atlas(layer : int, cell : Vector2i, atlases : Array, neighbors_to_return : Array) -> Array[Vector2i]:
	var neighbors_to_return_matching : Array[Vector2i] = []
	for side in neighbors_to_return:
		var neighbor := get_neighbor_cell(cell, side)
		if get_cell_atlas_coords(layer, neighbor) in atlases:
			neighbors_to_return_matching.append(neighbor)
	return neighbors_to_return_matching

func get_atlas_of_cells(layer : int, cells : Array[Vector2i]) -> Array[Vector2i]:
	var atlas_cells : Array[Vector2i] = []
	atlas_cells.resize(cells.size())
	
	for i in cells.size():
		var atlas : Vector2i = get_cell_atlas_coords(layer, cells[i])
		atlas_cells[i] = atlas
	
	return atlas_cells
