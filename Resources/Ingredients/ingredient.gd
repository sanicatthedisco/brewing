class_name Ingredient

enum State {POWDER, LIQUID}

var name: String
var state: State
var color: Color
var color_mult: float

func _init(p_name: String, p_state: State, p_color: Color, p_color_mult: float = 1.0) -> void:
	name = p_name
	state = p_state
	color = p_color
	color_mult = p_color_mult
