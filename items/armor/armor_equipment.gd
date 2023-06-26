extends Equipment
class_name ArmorEquipment

@export_dir var appearance_directory : String

var appearance : Dictionary

const PLAYER_APPEARANCE_MAP = {
	1 : "Right",
	2 : "RightDown",
	3 : "Down",
	4 : "LeftDown",
	5 : "Left",
	6 : "LeftUp",
	7 : "Up",
	8  : "RightUp",
}
const PLAYER_SPRITES_MAP = [
	"head",
	"torso",
	"leg_left",
	"leg_right",
]


func _ready() -> void:
	_initialize_appearance()

func _initialize_appearance():
	for num in PLAYER_APPEARANCE_MAP:
		appearance[PLAYER_APPEARANCE_MAP[num]] = {}
	
	for sprite in PLAYER_SPRITES_MAP:
		var files = DirAccess.open(appearance_directory +  "/" + sprite).get_files()
		
		for num in PLAYER_APPEARANCE_MAP:
			var path = appearance_directory +  "/" + sprite + "/"
			for file in files:
				if file.begins_with(sprite + str(num)):
					path = path + file
					break
			appearance[PLAYER_APPEARANCE_MAP[num]][sprite] = load(path)








