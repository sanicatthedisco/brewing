extends Node2D

@export var capacity := 100.0
@export var fill := 0.0:
	set(value):
		fill = clampf(value, 0.0, capacity)
		_update_liquid()

@onready var liquid: ColorRect = $Mask/Liquid
@onready var full_y := liquid.position.y 

func _update_liquid():
	if not is_node_ready():
		return
	liquid.position.y = full_y - liquid.size.y * (fill / capacity)

func _process(delta):
	fill += 0.3
