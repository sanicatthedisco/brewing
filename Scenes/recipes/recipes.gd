extends Node2D

var active = false

func _on_node_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not active:
				active = true
				$ActualRecipes.visible = true
			else:
				active = false
				$ActualRecipes.visible = false
