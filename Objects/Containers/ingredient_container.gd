class_name IngredientContainer
extends Node2D

@onready var mask: Sprite2D = $Mask
@onready var liquid: ColorRect = $Mask/Liquid
@onready var empty_y := liquid.position.y 

signal overflow(ing: Ingredient, amount: float)

var contents: Dictionary[Ingredient, float]
var capacity: float
var fill: float

var floor_rows = PackedInt32Array()

func _ready():
	_build_floor_map()

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

func _update_fill() -> void:
	fill = 0
	for ingredient in contents:
		if ingredient.state == Ingredient.State.LIQUID:
			fill += contents[ingredient]
	
	_update_liquid()
	print(fill)

#region Liquid rendering
func get_liquid_surface_y():
	return liquid.global_position.y + 20

func _build_floor_map():
	var img := mask.texture.get_image()
	floor_rows.resize(img.get_width())
	for x in img.get_width():
		floor_rows[x] = -1                       # -1 means "no interior in this column"
		for y in range(img.get_height() - 1, -1, -1):   # scan bottom to top
			if img.get_pixel(x, y).a > 0.5:
				floor_rows[x] = y
				break

func get_landing_y(world_x: float) -> float:
	# world x -> pixel column in the texture
	var local_x := mask.to_local(Vector2(world_x, 0.0)).x
	var col := int(local_x + mask.texture.get_width() * 0.5)
	if col < 0 or col >= floor_rows.size() or floor_rows[col] < 0:
		return get_liquid_surface_y()

	# pixel row -> world y
	var floor_local_y = floor_rows[col] - mask.texture.get_height() * 0.5
	var floor_world_y := mask.to_global(Vector2(0.0, floor_local_y)).y

	return minf(get_liquid_surface_y(), floor_world_y)

func _update_liquid():
	if not is_node_ready():
		return
	liquid.position.y = empty_y - liquid.size.y * (fill / capacity)
#endregion
