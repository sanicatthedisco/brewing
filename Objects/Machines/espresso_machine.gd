extends Node2D

@onready var body: Sprite2D = $Body
@onready var body_pressed: Sprite2D = $BodyPressed
@onready var container_area: Area2D = $ContainerArea

@onready var stream: Line2D = $Stream
@onready var spout: Marker2D = $Spout

var active := false
var dispense_target = null
var fill_rate := 1.0

func _ready():
	body_pressed.visible = false
	stream.default_color = Ingredients.ESPRESSO.color

func _process(delta):
	if active and dispense_target != null:
		(dispense_target as IngredientContainer).add_ingredient(Ingredients.ESPRESSO, fill_rate * delta)
		_update_stream()
		(dispense_target as IngredientContainer).update_stream(spout.global_position, Ingredients.ESPRESSO.color)

func _input_event(viewport, event, shape_idx):
	if _cursor_over_draggable():
		return
	if event is InputEventMouseButton and \
		event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_begin_dispensing()

func _input(event):
	if event is InputEventMouseButton and \
		event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_end_dispensing()
			
func _begin_dispensing():
	body_pressed.visible = true
	active = true
	for body in container_area.get_overlapping_bodies():
		if body is IngredientContainer:
			dispense_target = body
			break

func _end_dispensing():
	body_pressed.visible = false
	active = false
	if dispense_target != null:
		dispense_target.internal_stream.visible = false

func _update_stream():
	stream.visible = true
	stream.clear_points()
	stream.add_point(stream.to_local(spout.global_position))
	stream.add_point(stream.to_local(
		Vector2(spout.global_position.x, dispense_target.get_global_mask_top_y()))
	)

func _cursor_over_draggable() -> bool:
	var params := PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_bodies = true
	params.collide_with_areas = false
	var hits := get_world_2d().direct_space_state.intersect_point(params, 8)
	for hit in hits:
		if hit.collider is Draggable:
			return true
	return false
				
