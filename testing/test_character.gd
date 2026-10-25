
extends CharacterBody2D

var dialogue_lines: Array[String] = [
	"hey",
	"Wanna Sper",
    "ssfkdjd djdd"
]

func _ready() -> void:
	print("TEST CHARACTER READY")

	await get_tree().process_frame

	print("Calling DialogueManager!")

	DialogueManager.start_dialog(
		global_position + Vector2(100, -100),
		dialogue_lines,
		
	)
