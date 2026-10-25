class_name Character extends CharacterBody2D

@export var pre_order_dialogue: Array[String]

@export var post_order_dialogue: Array[String]

var move_speed = 200.0
var target_x = 400.0
var dialogue_started = false

func _physics_process(delta: float) -> void:
	if position.x < target_x:
		position.x += move_speed * delta
	elif not dialogue_started:
		dialogue_started = true
		start_npc_dialogue()
		
func start_npc_dialogue() -> void:
	await get_tree().create_timer(2.0).timeout

	DialogueManager.start_dialog(
		#global_position + Vector2(100, -100),
		#dialogue_lines,
		Vector2(1200, 400),
		pre_order_dialogue,
	)
