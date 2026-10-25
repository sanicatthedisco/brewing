extends Node2D

@export var serving_mat: ServingMat
@export var character: Character
@export var glass: IngredientContainer

func _ready():
	serving_mat.item_served.connect(_serve_order)
	character.ready_for_order.connect(_enable_orders)
	glass.contents_start = {Ingredients.ESPRESSO: 1, Ingredients.MILK: 2.5}

func _enable_orders():
	serving_mat.active = true

func _serve_order(item: IngredientContainer):
	character.recieve_order(item)
