extends Entity
class_name Player

@onready var inventory_instances_node := $InventoryInstances
@onready var area_of_interaction := $AreaOfInteraction

signal fell()

func _physics_process(delta):
	super(delta)
	
	walk(Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")), delta)
	
	if Input.is_action_just_pressed("interact"):
		interact()
	
	#if Input.is_action_pressed("use1") && has_item_in_slot([GameManager.ITEM_TYPE.WEAPON, 0]):
	#	use_weapon(inventory_instances[GameManager.ITEM_TYPE.WEAPON][0])
	#elif Input.is_action_pressed("use2") && has_item_in_slot([GameManager.ITEM_TYPE.WEAPON, 1]):
	#	use_weapon(inventory_instances[GameManager.ITEM_TYPE.WEAPON][1])

func got_off_the_ground():
	fall()

func die():
	fell.emit()

func use_weapon(weapon_instance):
	weapon_instance.use()


func interact():
	if area_of_interaction.object_to_interact:
		area_of_interaction.object_to_interact.interact(self)

"""
# INVENTORY RELATED FUNCTIONS =====================
func pick_up_grounded_item(grounded_item):
	var item_key = grounded_item.item_key
	
	if !is_item_added:
		create_grounded_item(item_key)



func drop_item(slot):
	create_grounded_item(inventory[slot[0]][slot[1]])
	
	remove_item(slot)

func create_grounded_item(item_key):
	var grounded_item = GroundedItem.instantiate()
	grounded_item.set_item_key(item_key)
	GameManager.add_instance(grounded_item)
	grounded_item.global_position = global_position

func remove_item(slot):
	if has_item_in_slot(slot):
		inventory[slot[0]][slot[1]] = null
		inventory_changed.emit(null, slot)
	else:
		printerr("Removing empty slot")

func has_item_in_slot(slot):
	return inventory_instances[slot[0]].has(slot[1]) && inventory_instances[slot[0]][slot[1]]

func on_inventory_changed(item_key, slot):
	if item_key:
		var item_instance = item_key.scene.instantiate()
		inventory_instances[slot[0]][slot[1]] = item_instance
		inventory_instances_node.add_child(item_instance)
	elif has_item_in_slot(slot):
		var item_instance = inventory_instances[slot[0]][slot[1]]
		inventory_instances_node.remove_child(item_instance)
		item_instance.queue_free()
		inventory_instances[slot[0]][slot[1]] = null
	
	
	
	# UPDATING ARMOR =========
	if has_item_in_slot([GameManager.ITEM_TYPE.ARMOR, 0]):
		sprite.texture = inventory_instances[GameManager.ITEM_TYPE.ARMOR][0].player_texture
	else:
		sprite.texture = deafult_texture

"""





















