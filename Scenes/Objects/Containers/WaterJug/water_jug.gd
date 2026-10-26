extends Pourable

func _ready():
	super()
	add_ingredient(Ingredients.WATER, 100)
	print(fill)

func _begin_pouring(target: IngredientContainer):
	super(target)
	pour_dir = 1
