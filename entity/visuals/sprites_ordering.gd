extends Node2D
class_name EntityVisualsSpritesOrdering



@onready var leg_left = $LegLeft
@onready var leg_right = $LegRight

func place_leg_left_on_top():
	move_child(leg_right, 0)

func place_leg_right_on_top():
	move_child(leg_left, 0)
