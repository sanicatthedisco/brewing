@tool
extends StaticBody2D

@export var width: float

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var rim = collider.shape as SegmentShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	rim.a.x = -width/2
	rim.b.x = width/2
