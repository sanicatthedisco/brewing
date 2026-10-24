class_name Recipe

var inputs: Dictionary[Ingredient, float]
var outputs: Dictionary[Ingredient, float]

func _init(p_inputs, p_outputs):
	inputs = p_inputs
	outputs = p_outputs
