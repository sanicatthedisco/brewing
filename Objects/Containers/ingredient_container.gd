class_name IngredientContainer extends Pourable

@onready var mask: Sprite2D = $Mask
@onready var liquid: ColorRect = $Mask/Liquid
@onready var internal_stream: Line2D = $Mask/InternalStream
@onready var empty_y := liquid.position.y 

signal overflow(ing: Ingredient, amount: float)

var contents: Dictionary[Ingredient, float]
@export var capacity: float
@export var fill: float

var floor_rows = PackedInt32Array()

func _ready():
	super()
	internal_stream.visible = false
	add_ingredient(Ingredients.WATER, 8)

func add_ingredient(ing: Ingredient, amount: float) -> void:
	if ing not in contents:
		contents[ing] = 0
	
	if fill + amount < capacity:
		contents[ing] += amount
	else:
		overflow.emit(ing, amount)
	
	_update_fill()

func remove_ingredient(ing: Ingredient, amount: float) -> void:
	assert(ing in contents.keys())
	assert(contents[ing] >= amount)
	contents[ing] -= amount
	
	_update_fill()

func _pour_out_contents(amount: float) -> bool:
	if amount > fill:
		return false
	for ing in contents:
		remove_ingredient(ing, amount)
	return true

func _update_fill() -> void:
	fill = 0
	for ingredient in contents:
		if ingredient.state == Ingredient.State.LIQUID:
			fill += contents[ingredient]
	
	_update_liquid()

#region Liquid rendering
func get_liquid_surface_y():
	return liquid.global_position.y

func update_stream(spout_pos: Vector2):
	var local_pos = internal_stream.to_local(spout_pos)
	internal_stream.visible = true
	internal_stream.clear_points()
	internal_stream.add_point(Vector2(local_pos.x, get_liquid_surface_y()))
	internal_stream.add_point(local_pos)

func _update_liquid():
	if not is_node_ready():
		return
	liquid.position.y = empty_y - liquid.size.y * (fill / capacity)
	
func get_global_mask_top_y():
	return mask.to_global(mask.get_rect().position).y + 20
#endregion
