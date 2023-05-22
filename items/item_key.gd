extends Resource
class_name ItemKey

enum ITEM_TYPE {ARMOR, WEAPON, ACCESSORY, RELIC, CRAFTING}

@export var key : String
@export var item_type : ITEM_TYPE
@export var instance : PackedScene
@export var icon : Texture2D = preload("res://items/no_sprite.png")
@export var grounded_sprite : Texture2D = preload("res://items/no_sprite.png")
@export var ui_name : String
@export_multiline var ui_description : String 

var amount : int = 0
