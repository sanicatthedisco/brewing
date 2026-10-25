class_name Character extends CharacterBody2D

@export var pre_order_dialogue: Array[String]

@export var post_order_dialogue: Array[String]

func _ready() -> void:
	await get_tree().process_frame

	DialogueManager.start_dialog(
		global_position + Vector2(100, -100),
		pre_order_dialogue
	)
