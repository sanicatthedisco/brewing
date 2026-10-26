extends Pourable

func _ready():
	super()
	add_ingredient(Ingredients.MILK, 100)

func _begin_pouring(target: IngredientContainer):
	super(target)
	pour_dir = 1
