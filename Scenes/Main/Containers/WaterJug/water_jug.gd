extends Pourable

func _ready():
	super()
	ingredient = Ingredients.WATER

func _begin_pouring(target: IngredientContainer):
	super(target)
	pour_dir = 1
