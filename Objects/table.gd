@tool
extends StaticBody2D

@export var width: float

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var rim = collider.shape as SegmentShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	rim.a.x = -width/2
	rim.b.x = width/2

func _draw():
	if Engine.is_editor_hint():
		draw_set_transform_matrix(collider.transform)
		draw_line(Vector2(-width/2, position.y), Vector2(width/2, position.y), Color.BLACK, 4.0)
