extends Node2D

const lines: Array[String] = [
	"hey",
	"Wanna Sper",
	"ssfkdjd djdd",
]
#if the player press space, a NPC will show up and automatically start the dialog
#func _unhandled_input(event):
	#if event.is_action_pressed("show_up"):
		#if interaction_area.get
		#InteractionLabel.hide_label():
			#dialogManager.start_dialog(global_position, lines)
			#sprite.flip_h = true if 
