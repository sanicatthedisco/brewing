class_name Pourable
extends Draggable

@export var pour_angle := -90.0
@export var upright_angle := 0.0
var ingredient: Ingredient = Ingredients.WATER
var fill_rate := 3

var pouring := false
var pour_dir := 1

var stream_fall_speed := 500.0

var pour_target: IngredientContainer = null

@onready var stream: Line2D = $Stream
@onready var spout: Area2D = $Spout

func _ready():
	super()
	detector.area_entered.connect(_on_area_entered)
	spout.area_exited.connect(_on_area_exited)
	
	
func _process(delta):
	if dragging:
		if pouring:
			rotation = lerp_angle(rotation, pour_angle * pour_dir, 0.1)
			if abs(rotation_degrees) > abs(pour_angle) * 0.8:
				if _pour_out_contents(fill_rate * delta):
					pour_target.update_stream(spout.global_position)
					_fill_target(pour_target, delta)
					_update_stream()
					
		else:
			rotation = lerp_angle(rotation, upright_angle, 0.1)
	
func _update_stream():
	stream.visible = true
	stream.clear_points()
	stream.add_point(stream.to_local(spout.global_position))
	stream.add_point(stream.to_local(
		Vector2(spout.global_position.x, pour_target.get_global_mask_top_y()))
	)

func _pour_out_contents(amount: float) -> bool:
	return true

func _fill_target(target: IngredientContainer, delta: float):
	target.add_ingredient(ingredient, fill_rate * delta)

func _begin_pouring(target: IngredientContainer):
	pouring = true
	pour_target = target
	# Change pouring direction based on entered side
	if global_position.x < pour_target.global_position.x:
		pour_dir = -1
	else:
		pour_dir = 1

func _end_pouring():
	if (pour_target != null):
		pour_target.internal_stream.visible = false
	pouring = false
	pour_target = null
	stream.clear_points()
	stream.visible = false

func _on_area_entered(area: Area2D):
	if area.name == "PourZone" and not is_ancestor_of(area) and dragging:
		_begin_pouring(area.get_parent())

func _on_area_exited(area):
	if area.name == "PourZone" and dragging:
		_end_pouring()

func _end_dragging():
	rotation = upright_angle
	_end_pouring()
	super()
