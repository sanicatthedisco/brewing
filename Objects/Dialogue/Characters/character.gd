class_name Character extends CharacterBody2D

@export var pre_order_dialogue: Array[String]
@export var post_order_dialogue: Array[String]

enum State {ORDERING, APPEARING, WAITING}
var state: State = State.APPEARING

var move_speed = 200.0
var target_x = 400.0
var dialogue_started = false

func _physics_process(delta: float) -> void:
	match state:
		State.APPEARING:
			if position.x < target_x:
				position.x += move_speed * delta
			else:
				start_npc_dialogue(pre_order_dialogue)
				state = State.ORDERING
		
func start_npc_dialogue(dialog: Array[String]) -> void:
	await get_tree().create_timer(1.0).timeout
	
	DialogueManager.dialog_complete.connect(_on_dialog_end)
	DialogueManager.start_dialog(
		#global_position + Vector2(100, -100),
		#dialogue_lines,
		Vector2(1200, 400),
		dialog,
	)

func _on_dialog_end():
	DialogueManager.dialog_complete.disconnect(_on_dialog_end)
	match state:
		State.ORDERING:
			state = State.WAITING
