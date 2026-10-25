extends Node2D
var button_type = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_type = "start"
	$fade_transition.show()
	$fade_transition/fade_timer.start()
	$fade_transition/AnimationPlayer.play("fade_in")
	


func _on_button_start_pressed() -> void:
	if button_type == "start":
		get_tree().change_scene_to_file("res://main.tscn") 
	
