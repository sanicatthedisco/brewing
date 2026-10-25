@tool
extends StaticBody2D

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var rim = collider.shape as SegmentShape2D
