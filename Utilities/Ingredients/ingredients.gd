class_name Ingredients

static var _by_name: Dictionary[String, Ingredient] = {}

static var WATER := _reg(Ingredient.new("Water", Ingredient.State.LIQUID, Color.SKY_BLUE))
static var ESPRESSO := _reg(Ingredient.new("Espresso", Ingredient.State.LIQUID, Color("4E312D"), 5.0))
static var SUGAR := _reg(Ingredient.new("Sugar", Ingredient.State.POWDER, Color.WHITE))
static var MILK := _reg(Ingredient.new("Milk", Ingredient.State.LIQUID, Color.FLORAL_WHITE))
static var BLOOD := _reg(Ingredient.new("Blood", Ingredient.State.LIQUID, Color.DARK_RED))

static func _reg(ingredient: Ingredient) -> Ingredient:
	if _by_name.has(ingredient.name):
		push_error("Ingredients: duplicate name '%s'" % ingredient.name)
	_by_name[ingredient.name] = ingredient
	return ingredient

static func from_name(id: String) -> Ingredient:
	if not _by_name.has(id):
		push_error("Ingredients: unknown ingredient '%s'" % id)
		return null
	return _by_name[id]

static func all() -> Array[Ingredient]:
	var result: Array[Ingredient] = []
	result.assign(_by_name.values())
	return result
