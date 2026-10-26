class_name Garnish extends Draggable

@export var garnish_name: String

func _end_dragging():
	for body in detector.get_overlapping_bodies():
		if body is IngredientContainer:
			body.apply_garnish(self)
			dragging = false
			return
	super()
