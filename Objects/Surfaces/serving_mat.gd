class_name ServingMat extends StaticBody2D

signal item_served(item: IngredientContainer)

@onready var detector: Area2D = $Detector
var active = false

func _physics_process(delta):
	if active:
		for body in detector.get_overlapping_bodies():
			if body is IngredientContainer:
				item_served.emit(body as IngredientContainer)
				active = false
