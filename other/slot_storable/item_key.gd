extends SlotStorable
class_name ItemKey

enum ITEM_TYPE {ARMOR, WEAPON, ACCESSORY, RELIC, MATERIAL}

@export var key : String
@export var item_type : ITEM_TYPE
@export var grounded_sprite : Texture2D = preload("res://items/no_sprite.png")
@export var equipment : Script
@export var equipment_stats : StatList
@export var progression_point : float
@export_flags("Forest", "Snow", "Jungle", "Desert", "Cave", "Beach") var biome : int
@export var recipes : Array[Recipe]

var amount : int = 0

var equipment_instance : Equipment

