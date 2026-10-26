class_name IngredientContainer extends Pourable

@onready var mask: Sprite2D = $Mask
@onready var liquid: ColorRect = $Mask/Liquid
@onready var internal_stream: Line2D = $Mask/InternalStream
@onready var empty_y := liquid.position.y 

signal overflow(ing: Ingredient, amount: float)

var contents_start: Dictionary[Ingredient, float]
@export var starting_fill: float
@export var starting_ingredient: String

var garnish = null

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
	
	for ingr in contents_start:
		add_ingredient(ingr, contents_start[ingr])

func apply_garnish(p_garnish: Garnish):
	garnish = p_garnish
	garnish.reparent(self)
	garnish.position = $GarnishSite.position

#region Internal contents rendering
func _update_contents() -> void:
	super()
	liquid.color = content_color
	liquid.position.y = empty_y - liquid.size.y * (fill / capacity)
	
func update_internal_stream(spout_pos: Vector2, color: Color):
	var local_pos = internal_stream.to_local(spout_pos)
	internal_stream.default_color = color
	internal_stream.visible = true
	internal_stream.clear_points()
	internal_stream.add_point(internal_stream.to_local(Vector2(spout_pos.x, get_liquid_surface_y())))
	internal_stream.add_point(internal_stream.to_local(Vector2(spout_pos.x, get_global_mask_top_y())))
#endregion
	
#region Helpers
func get_liquid_surface_y():
	return liquid.global_position.y
	
func get_global_mask_top_y():
	return mask.to_global(mask.get_rect().position).y + 20
	
func get_global_x_range() -> Vector2:
	var r := mask.get_rect()                       # local, already accounts for centering
	var left := mask.to_global(r.position).x
	var right := mask.to_global(r.end).x
	return Vector2(minf(left, right), maxf(left, right))   # x = left, y = right
#endregion
