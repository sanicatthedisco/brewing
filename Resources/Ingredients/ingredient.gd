class_name Ingredient

enum State {POWDER, LIQUID}

var name: String
var state: State
var color: Color

func _init(p_name: String, p_state: State, p_color: Color) -> void:
	name = p_name
	state = p_state
	color = p_color
