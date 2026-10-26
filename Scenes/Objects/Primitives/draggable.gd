class_name Draggable
extends RigidBody2D

var dragging := false
var _saved_layer := 0
var _saved_mask := 0

@onready var detector: Area2D = $InteractionDetector

func _physics_process(_delta):
	# If dragging, snap to mouse pos
	if dragging:
		global_position = get_global_mouse_position()

# Grabbing
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and \
		event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_begin_dragging()

# Letting go
func _input(event):
	if event is InputEventMouseButton and \
		event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if dragging:
				_end_dragging()
		
func _begin_dragging():
	# Must freeze rigidbody physics
	dragging = true
	freeze = true
	_saved_layer = collision_layer
	_saved_mask = collision_mask
	collision_layer = 0      # nothing can hit me
	collision_mask = 0       # I don't hit anything

func _end_dragging():
	collision_layer = _saved_layer
	collision_mask = _saved_mask
	# Reset physics properties
	PhysicsServer2D.body_set_state(get_rid(), PhysicsServer2D.BODY_STATE_TRANSFORM, transform)
	PhysicsServer2D.body_set_state(get_rid(), PhysicsServer2D.BODY_STATE_LINEAR_VELOCITY, Vector2.ZERO)
	PhysicsServer2D.body_set_state(get_rid(), PhysicsServer2D.BODY_STATE_ANGULAR_VELOCITY, 0.0)
	
	# Unfreeze
	dragging = false
	freeze = false
