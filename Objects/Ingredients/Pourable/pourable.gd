extends Draggable

@export var pour_angle := -90.0
@export var upright_angle := 0.0
@export var fill_rate := 30.0

var pouring := false
var pour_dir := 1

var max_stream_y: float
var stream_fall_speed := 500.0
var stream_made_contact := false

var pour_target: Bowl = null

@onready var stream: Line2D = $Stream
@onready var spout: Area2D = $Spout

func _ready():
	super()
	detector.area_entered.connect(_on_area_entered)
	spout.area_exited.connect(_on_area_exited)
	
	
func _physics_process(delta):
	super(delta)
	if dragging:
		if pouring:
			rotation = lerp_angle(rotation, pour_angle * pour_dir, 0.1)
			if abs(rotation_degrees) > abs(pour_angle) * 0.8:
				_update_stream(delta)
				if stream_made_contact:
					pour_target.add_liquid(fill_rate * delta)
		else:
			rotation = lerp_angle(rotation, upright_angle, 0.1)

func _update_stream(delta):
	var stream_y: float
	var surf_y = pour_target.get_landing_y(spout.global_position.x)
	if not stream_made_contact:
		max_stream_y += stream_fall_speed * delta;
		stream_y = minf(maxf(max_stream_y, spout.global_position.y), surf_y)
		if stream_y >= surf_y:
			stream_made_contact = true
	else:
		stream_y = surf_y
	
	stream.clear_points()
	stream.add_point(spout.global_position)
	stream.add_point(Vector2(spout.global_position.x, stream_y))

func _begin_pouring(target: Bowl):
	pouring = true
	pour_target = target
	max_stream_y = spout.global_position.y
	stream_made_contact = false
	# Change pouring direction based on entered side
	if global_position.x < pour_target.global_position.x:
		pour_dir = -1
	else:
		pour_dir = 1

func _end_pouring():
	pouring = false
	pour_target = null
	stream.clear_points()

func _on_area_entered(area: Area2D):
	if area.name == "PourZone" and dragging:
		_begin_pouring(area.get_parent())

func _on_area_exited(area):
	if area.name == "PourZone" and dragging:
		_end_pouring()


func _end_dragging():
	rotation = upright_angle
	_end_pouring()
	super()
