class_name Pourable
extends Draggable

# Contents
var _contents: Dictionary[Ingredient, float]
var fill := 0.0
@export var capacity: float = 100

# Pouring
var pouring := false
var fill_rate := 3.0
var pour_target: IngredientContainer = null

# Motion
var pour_angle := -90.0
var upright_angle := 0.0
var pour_dir := 1
var pour_zone: Area2D = null
var stream_fall_speed := 500.0
var content_color: Color


@onready var stream: Line2D = $Stream
@onready var spout: Area2D = $SpoutStuff/Spout

func _ready():
	detector.area_entered.connect(_on_area_entered)
	spout.area_exited.connect(_on_area_exited)
	
func _process(delta):
	if dragging and pouring:
		rotation = lerp_angle(rotation, pour_angle * pour_dir, 0.1)
		
		# If tilted enough
		if abs(rotation_degrees) > abs(pour_angle) * 0.8 and pour_target:
			# Pour if able
			var amount: float = fill_rate * delta
			if _is_spout_over_target() and amount <= fill and pour_target.has_room_for(amount):
				_transfer_contents(amount)
			else:
				_end_pouring()
					
	if dragging and not pouring:
		rotation = lerp_angle(rotation, upright_angle, 0.1)

#region Manage contents
func add_ingredient(ing: Ingredient, amount: float) -> void:
	if ing not in _contents:
		_contents[ing] = 0
	
	if fill + amount > capacity:
		amount = capacity - fill
		
	_contents[ing] += amount
	fill += amount
	_update_contents()

func remove_ingredient(ing: Ingredient, amount: float) -> void:
	assert(ing in _contents.keys())
	assert(_contents[ing] >= amount, "Cannot remove ingredient when contents are less than amount to remove. Ingredient: %s, Contents: %f, Amount: %f" % [ing.name, _contents[ing], amount])
	_contents[ing] -= amount
	fill -= amount
	_update_contents()

func has_room_for(amount: float):
	return fill + amount <= capacity

func get_contents(): return _contents
#endregion

#region Pouring logic
func _transfer_contents(amount: float):
		assert(amount <= fill, "Amount to transfer is greater than fill")
		# Transfer contents proportional to their abundance
		var old_fill := fill
		for ing in _contents:
			var weighted_amount := amount * _contents[ing] / old_fill
			assert(weighted_amount < _contents[ing], "Weighted amount (%f) is more than amount remaining (%f), with fill %f" % [weighted_amount, _contents[ing], fill])
			remove_ingredient(ing, weighted_amount)
			pour_target.add_ingredient(ing, weighted_amount)
		
		# Update streams to match new fill level
		pour_target.update_internal_stream(spout.global_position, stream.default_color)
		_update_stream()

func _begin_pouring(target: IngredientContainer):
	stream.visible = true
	pouring = true
	pour_target = target
	
	# Change pouring direction based on entered side
	if global_position.x < pour_target.global_position.x:
		pour_dir = -1
		spout.global_position = $SpoutStuff/SpoutPosRight.global_position
	else:
		pour_dir = 1
		spout.global_position = $SpoutStuff/SpoutPosLeft.global_position

func _end_pouring():
	if (pour_target != null):
		pour_target.internal_stream.visible = false
	
	pouring = false
	stream.clear_points()
	stream.visible = false
	
	pour_target = null
	pour_zone = null


func _is_spout_over_target() -> bool:
	var range := pour_target.get_global_x_range()
	var x := spout.global_position.x
	return x >= range.x and x <= range.y
#endregion

#region Stream rendering
func _update_contents() -> void:
	var colors: Array[Color]
	var weights: Array[float]
	for ing in _contents:
		colors.append(ing.color)
		weights.append(_contents[ing] * ing.color_mult)
		
	content_color = ColorMixer.mix_rgb(colors, weights)
	stream.default_color = content_color

func _update_stream():
	assert(pour_target, "Pour target cannot be null")
	stream.visible = true
	stream.clear_points()
	stream.add_point(stream.to_local(spout.global_position))
	stream.add_point(stream.to_local(
		Vector2(spout.global_position.x, pour_target.get_global_mask_top_y()))
	)
#endregion

#region Collision
func _on_area_entered(area: Area2D):
	if area.name == "PourZone" and not is_ancestor_of(area) and dragging:
		_begin_pouring(area.get_parent())

func _on_area_exited(area):
	if area.name == "PourZone" and not is_ancestor_of(area) and dragging:
		#_end_pouring()
		pass

func _end_dragging():
	rotation = upright_angle
	_end_pouring()
	super()
#endregion
