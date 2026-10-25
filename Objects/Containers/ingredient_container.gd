class_name IngredientContainer extends Pourable

@onready var mask: Sprite2D = $Mask
@onready var liquid: ColorRect = $Mask/Liquid
@onready var internal_stream: Line2D = $Mask/InternalStream
@onready var empty_y := liquid.position.y 

signal overflow(ing: Ingredient, amount: float)

var contents: Dictionary[Ingredient, float]
var content_color: Color
@export var capacity: float
var fill := 0.0
@export var starting_fill: float
@export var starting_ingredient: String

func _ready():
	super()
	internal_stream.visible = false
	var ing: Ingredient
	if starting_ingredient == Ingredients.MILK.name:
		ing = Ingredients.MILK
	elif starting_ingredient == Ingredients.BLOOD.name:
		ing = Ingredients.BLOOD
	else:
		ing = Ingredients.WATER
	
	add_ingredient(ing, starting_fill)

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
	return true

func _fill_target(target: IngredientContainer, delta: float):
	for ing in contents:
		var weighted_amount := fill_rate * delta * contents[ing] / fill
		if contents[ing] > fill_rate * delta:
			remove_ingredient(ing, weighted_amount)
			target.add_ingredient(ing, weighted_amount)

func _update_fill() -> void:
	fill = 0
	var colors: Array[Color]
	var weights: Array[float]
	for ing in contents:
		if ing.state == Ingredient.State.LIQUID:
			fill += contents[ing]
			colors.append(ing.color)
			weights.append(contents[ing] * ing.color_mult)
		
		content_color = mix_rgb(colors, weights)
		
	liquid.color = content_color
	stream.default_color = content_color
	_update_liquid()
	
	if fill < 0.1 and pouring:
		_end_pouring()

#region Liquid rendering
func get_liquid_surface_y():
	return liquid.global_position.y

func update_stream(spout_pos: Vector2, color: Color):
	var local_pos = internal_stream.to_local(spout_pos)
	internal_stream.default_color = color
	internal_stream.visible = true
	internal_stream.clear_points()
	internal_stream.add_point(internal_stream.to_local(Vector2(spout_pos.x, get_liquid_surface_y())))
	internal_stream.add_point(internal_stream.to_local(Vector2(spout_pos.x, get_global_mask_top_y())))

func _update_liquid():
	if not is_node_ready():
		return
	liquid.position.y = empty_y - liquid.size.y * (fill / capacity)
	
func get_global_mask_top_y():
	return mask.to_global(mask.get_rect().position).y + 20
#endregion

# ingredient_container.gd
func get_global_x_range() -> Vector2:
	var r := mask.get_rect()                       # local, already accounts for centering
	var left := mask.to_global(r.position).x
	var right := mask.to_global(r.end).x
	return Vector2(minf(left, right), maxf(left, right))   # x = left, y = right

static func ryb_to_rgb(ryb: Vector3) -> Color:
	var r := ryb.x
	var y := ryb.y
	var b := ryb.z
	# Corner colors of the RYB cube (Gosset-Chen)
	var c000 := Vector3(1, 1, 1)
	var c100 := Vector3(1, 0, 0)
	var c010 := Vector3(1, 1, 0)
	var c110 := Vector3(1, 0.5, 0)
	var c001 := Vector3(0.163, 0.373, 0.6)
	var c101 := Vector3(0.5, 0, 0.5)
	var c011 := Vector3(0, 0.66, 0.2)
	var c111 := Vector3(0.2, 0.094, 0)
	var c00 := c000.lerp(c100, r)
	var c01 := c001.lerp(c101, r)
	var c10 := c010.lerp(c110, r)
	var c11 := c011.lerp(c111, r)
	var c0 := c00.lerp(c10, y)
	var c1 := c01.lerp(c11, y)
	var c := c0.lerp(c1, b)
	return Color(c.x, c.y, c.z)

static func rgb_to_ryb(c: Color) -> Vector3:
	var r := c.r
	var g := c.g
	var b := c.b
	var w := minf(r, minf(g, b))
	r -= w; g -= w; b -= w
	var mg := maxf(r, maxf(g, b))
	var y := minf(r, g)
	r -= y; g -= y
	if b > 0.0 and g > 0.0:
		b /= 2.0; g /= 2.0
	y += g
	b += g
	var my := maxf(r, maxf(y, b))
	if my > 0.0:
		var n := mg / my
		r *= n; y *= n; b *= n
	return Vector3(r, y, b)

static func mix_rgb(colors: Array, weights: Array) -> Color:
	var ryb_sum := Vector3.ZERO
	var ryb_total := 0.0
	var v_sum := 0.0
	var total := 0.0
	for i in colors.size():
		var c: Color = colors[i]
		var v := maxf(c.r, maxf(c.g, c.b))
		if v > 0.0:
			var base := Color(c.r / v, c.g / v, c.b / v)
			ryb_sum += rgb_to_ryb(base) * (weights[i] * v)
			ryb_total += weights[i] * v
		v_sum += v * weights[i]
		total += weights[i]
	if total <= 0.0 or ryb_total <= 0.0:
		return Color.BLACK
	var result := ryb_to_rgb(ryb_sum / ryb_total)
	var v_mix := v_sum / total
	return Color(result.r * v_mix, result.g * v_mix, result.b * v_mix)
