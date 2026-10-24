extends Draggable

@export var pour_angle := -90.0
@export var upright_angle := 0.0
var pouring := false
var pour_dir := 1

func _ready():
	super()
	detector.area_entered.connect(_on_area_entered)
	detector.area_exited.connect(_on_area_exited)
	
func _physics_process(delta):
	super(delta)
	if dragging:
		if pouring:
			rotation = lerp_angle(rotation, pour_angle * pour_dir, 0.1)
		else:
			rotation = lerp_angle(rotation, upright_angle, 0.1)
	

func _on_area_entered(area: Area2D):
	if area.name == "PourZone" and dragging:
		pouring = true
		if global_position.x < area.global_position.x:
			pour_dir = -1
		else:
			pour_dir = 1
		
func _on_area_exited(area):
	if area.name == "PourZone" and dragging:
		pouring = false

func _end_dragging():
	rotation = upright_angle
	pouring = false
	super()
