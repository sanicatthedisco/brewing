extends Node2D

var active = false

func _on_node_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("clicked")
			if not active:
				active = true
				$ActualLetters.visible = true
			else:
				active = false
				$ActualLetters.visible = false
