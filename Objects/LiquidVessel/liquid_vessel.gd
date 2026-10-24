extends RigidBody2D

var dragging := false

# Grabbing
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and \
		event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dragging = true
			freeze = true

# Letting go
func _input(event):
	if event is InputEventMouseButton and \
		event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if dragging:
				dragging = false
				freeze = false
				linear_velocity = Vector2.ZERO
				angular_velocity = 0.0

func _physics_process(_delta):
	if dragging:
		var t := Transform2D(rotation, get_global_mouse_position())
		PhysicsServer2D.body_set_state(get_rid(), PhysicsServer2D.BODY_STATE_TRANSFORM, t)
		PhysicsServer2D.body_set_state(get_rid(), PhysicsServer2D.BODY_STATE_LINEAR_VELOCITY, Vector2.ZERO)
		PhysicsServer2D.body_set_state(get_rid(), PhysicsServer2D.BODY_STATE_ANGULAR_VELOCITY, 0.0)
