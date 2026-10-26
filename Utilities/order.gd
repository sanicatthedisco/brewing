class_name Order extends Resource

var amount: float
var contents: Dictionary[Ingredient, float]
var garnish_name

func _init(p_amount: float, p_contents: Dictionary[Ingredient, float], p_garnish_name = null):
	amount = p_amount
	garnish_name = p_garnish_name
	
	# Normalize ingredient weights to 0-1 fractions
	var normalize: float
	for ing in p_contents:
		normalize += p_contents[ing]
	for ing in p_contents:
		contents[ing] = p_contents[ing] / normalize

func evaluate_container(container: IngredientContainer) -> Evaluation:
	var score := 0.0
	var actual_ratio: float
	var error: float
	var highest_error: float
	var highest_error_ingredient: Ingredient
	
	# Calculate ingredient errors for score
	for ing in container.get_contents():
		actual_ratio = container.get_contents()[ing] / container.fill
		if ing in contents.keys():
			error = abs((actual_ratio - contents[ing])/contents[ing])
			if error > highest_error:
				highest_error = error
				highest_error_ingredient = ing
			score = score + (1-error)
		else:
			score -= actual_ratio
	score = score / contents.size()
	
	# Evaluate how much was served
	var amount_error := 1 - (container.fill / amount)
	amount_error = clampf(amount_error, 0, 1)
	score *= 1 - amount_error
	
	
	# Take into account correct garnish
	var was_garnish_correct := true
	if garnish_name != null:
		if container.garnish == null:
			score -= 0.2
			was_garnish_correct = false
		elif container.garnish.garnish_name != garnish_name:
			score -= 0.2
			was_garnish_correct = false
	score = clampf(score, 0, score)
	return Evaluation.new(score, amount_error, highest_error_ingredient, was_garnish_correct)
		
