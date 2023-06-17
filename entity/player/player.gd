extends Entity
class_name Player

@onready var collectable_collector : Area2D = $CollectableCollector
var default_appearance

var inventory = Inventory.new()

func _ready() -> void:
	super()
	default_appearance = sprites.appearance
	
	inventory.item_equiped.connect(equip)
	inventory.item_unequiped.connect(unequip)
	
	collectable_collector.area_entered.connect(collect)

func collect(collectable : Area2D):
	collectable.collect(self)

func set_appearance(to : Dictionary):
	sprites.appearance = to
	sprites.set_sprites_to_appearance(sprites.current_appearance_direction)

func set_default_appearance():
	sprites.appearance = default_appearance
	sprites.set_sprites_to_appearance(sprites.current_appearance_direction)
