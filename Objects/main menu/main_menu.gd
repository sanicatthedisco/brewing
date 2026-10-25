extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_button_start_pressed() -> void:
	get.tree().change_scene_to_file("res://main.tscn") # Replace with function body.
