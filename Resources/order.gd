class_name Order extends Resource

var amount: float
var contents: Dictionary[Ingredient, float]

func _init(p_amount: float, p_contents: Dictionary[Ingredient, float]):
	amount = p_amount
	
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
	return score / contents.size()
		
