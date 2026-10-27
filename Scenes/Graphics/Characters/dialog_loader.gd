extends Node
const DIALOG_DIR := "res://Dialog"

var _data: Dictionary

func get_pre_order(day: int) -> Array[DialogLine]:
	var events := get_dialog_events(day)
	assert(events.has("pre_order"))
	return _parse_dialog(events["pre_order"])

func get_evaluation(day: int, score: float) -> Array[DialogLine]:
	var events := get_dialog_events(day)
	assert(events.has("evaluation"), "DialogLoader: day %d has no evaluation" % day)
	assert(not is_nan(score))
 
	# Picks the highest tier the score reaches, regardless of order in the file.
	var best := -INF
	var lines: Array[DialogLine] = []
	for tier: Dictionary in events["evaluation"]:
		var min_score := float(tier.get("min_score", 0.0))
		if score >= min_score and min_score > best:
			best = min_score
			lines = _parse_dialog(tier["dialog"])
	return lines
 
 
func get_additional_evaluation(day: int, flag: String) -> Array[DialogLine]:
	var events := get_dialog_events(day)
	var additional: Dictionary = events.get("additional_evaluation", {})
	if not additional.has(flag):
		return []
	# Each reaction is a single block, not an array of blocks.
	return _parse_dialog_block(additional[flag])

func get_order(day: int) -> Order:
	var events := get_dialog_events(day)
	assert(events.has("order"))
	var order: Dictionary = events["order"]
	
	var composition: Dictionary[Ingredient, float]
	for ing in order["composition"]:
		composition[Ingredients.from_name(ing)] = order["composition"][ing]
	var garnish: String = order["garnish"] if order.has("garnish") else null
	return Order.new(order["amount"], composition, order["garnish"])

func get_dialog_events(day: int) -> Dictionary:
	return _data["day_%d" % day]

func _parse_dialog(dialog: Array) -> Array[DialogLine]:
	var lines: Array[DialogLine] = []
	for block: Dictionary in dialog:
		lines.append_array(_parse_dialog_block(block))
	return lines
		
func _parse_dialog_block(block: Dictionary) -> Array[DialogLine]:
	assert(block.size() == 1, "DialogLoader: a dialog block should have exactly one speaker.")
 
	var lines: Array[DialogLine] = []
	var speaker: String = block.keys()[0]
	var content = block[speaker]
	# A bare string is one line. Looping over it directly would yield single characters.
	if content is String:
		lines.append(DialogLine.new(speaker, content))
	else:
		for line: String in content:
			lines.append(DialogLine.new(speaker, line))
	return lines

#
#func _load_file(path: String) -> Variant:
	#var text := FileAccess.get_file_as_string(path)
	#assert(not text.is_empty(), "DialogLoader: %s is empty or unreadable" % path)
	#
	#var json := JSON.new()
	#assert(json.parse(text) == OK, "DialogLoader: %s line %d: %s" 
		#% [path, json.get_error_line(), json.get_error_message()])
	#assert(typeof(json.data) == TYPE_DICTIONARY, "DialogLoader: %s top level must be an object" % path)
	#
	#return json.data
	#
