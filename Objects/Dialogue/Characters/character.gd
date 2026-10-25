class_name Character extends CharacterBody2D

@export var pre_order_dialogue: Array[String]
@export var speech_sound = preload("res://Assets/sounds/dandys-world-classic-text-box-sound.mp3")
@export var post_order_dialogue: Array[String]

var pre_order_dialog: Dialog
var evaluation_dialogs: Dictionary[float, Dialog]

var order: Order

signal ready_for_order

enum State {ORDERING, APPEARING, WAITING, EVALUATING}
var state: State = State.APPEARING

var move_speed = 200.0
var target_x = 400.0
var dialogue_started = false

var dialog_pos := Vector2(1200, 400)

func _ready():
	print(pre_order_dialog)

func _physics_process(delta: float) -> void:
	match state:
		State.APPEARING:
			if position.x < target_x:
				position.x += move_speed * delta
			else:
				start_npc_dialogue(pre_order_dialog.lines)
				state = State.ORDERING


func start_npc_dialogue(dialog: Array[String]) -> void:
	await get_tree().create_timer(0.2).timeout
	send_dialog(pre_order_dialog)

func recieve_order(item: IngredientContainer):
	var score := order.evaluate_container(item)
	print("Score: ", score)
	var dialog: Dialog
	for score_cutoff in evaluation_dialogs:
		if score >= score_cutoff:
			dialog = evaluation_dialogs[score_cutoff]
	send_dialog(dialog)

func send_dialog(dialog: Dialog):
	DialogueManager.dialog_complete.connect(_on_dialog_end)
	DialogueManager.start_dialog(dialog_pos, dialog.lines)

func _on_dialog_end():
	DialogueManager.dialog_complete.disconnect(_on_dialog_end)
	match state:
		State.ORDERING:
			state = State.WAITING
			ready_for_order.emit()

