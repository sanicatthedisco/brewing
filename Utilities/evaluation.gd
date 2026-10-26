class_name Evaluation

var score: float
var highest_error_ingredient: Ingredient
var was_garnish_correct: bool
var amount_error: float

func _init(p_score: float, p_amount_error: float, p_highest_error_ingredient: Ingredient, p_was_garnish_correct: bool):
	score = p_score
	highest_error_ingredient = p_highest_error_ingredient
	was_garnish_correct = p_was_garnish_correct
	amount_error = p_amount_error
