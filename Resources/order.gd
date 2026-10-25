class_name Order extends Resource

var amount: float
var contents: Dictionary[Ingredient, float]
var garnish_name: String

func _init(p_amount: float, p_contents: Dictionary[Ingredient, float], p_garnish_name = null):
	amount = p_amount
	garnish_name = p_garnish_name
	
	# Normalize ingredient weights to 0-1 fractions
	var normalize: float
	for ing in p_contents:
		normalize += p_contents[ing]
	for ing in p_contents:
		contents[ing] = p_contents[ing] / normalize

func evaluate_container(container: IngredientContainer) -> float:
	var score := 0.0
	var actual_ratio: float
	var error: float
	for ing in container.contents:
		actual_ratio = container.contents[ing] / container.fill
		if ing in contents.keys():
			error = abs((actual_ratio - contents[ing])/contents[ing])
			score = score + (1-error)
		else:
			score -= actual_ratio
	score = score / contents.size()
	
	if garnish_name != null:
		if container.garnish == null:
			score -= 0.5
		elif container.garnish.garnish_name != garnish_name:
			score -= 0.5
	return clampf(score, 0, score)
		
