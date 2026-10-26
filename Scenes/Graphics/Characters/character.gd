class_name Character extends CharacterBody2D

@export var pre_order_dialogue: Array[String]
@export var speech_sound = preload("res://Assets/sounds/dandys-world-classic-text-box-sound.mp3")
@export var post_order_dialogue: Array[String]

var pre_order_dialog: Dialog
var evaluation_dialogs: Dictionary[float, Dialog]
var incorrect_garnish_dialog: Dialog = Dialog.new([])
var small_amount_dialog: Dialog = Dialog.new([])

var order: Order

signal ready_for_order
signal order_complete
signal took_drink

enum State {ORDERING, APPEARING, WAITING, EVALUATING, LEAVING}
var state: State = State.APPEARING

var move_speed = 200.0 if not GS.debug else 1000.0
var target_x = 400.0
var dialogue_started = false

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
		State.LEAVING:
			if position.x > target_x:
				position.x -= move_speed * delta
			else:
				order_complete.emit()


func start_npc_dialogue(dialog: Array[DLine]) -> void:
	await get_tree().create_timer(0.2).timeout
	send_dialog(pre_order_dialog)

func recieve_order(item: IngredientContainer):
	state = State.EVALUATING
	var eval := order.evaluate_container(item)
	var dialog: Dialog = evaluation_dialogs[0.0]
	for score_cutoff in evaluation_dialogs:
		if eval.score >= score_cutoff:
			dialog = evaluation_dialogs[score_cutoff]
	
	if not eval.was_garnish_correct:
		dialog = Dialog.combine([dialog, incorrect_garnish_dialog])
	if eval.amount_error > 0.2:
		dialog = Dialog.combine([dialog, small_amount_dialog])
	
	print(dialog.lines)
	send_dialog(dialog)

func send_dialog(dialog: Dialog):
	DialogManager.dialog_complete.connect(_on_dialog_end)
	DialogManager.start_dialog(DialogManager.Speaker.CUSTOMER, dialog, speech_sound)

func _on_dialog_end():
	DialogManager.dialog_complete.disconnect(_on_dialog_end)
	match state:
		State.ORDERING:
			state = State.WAITING
			ready_for_order.emit()
		State.EVALUATING:
			target_x = 0
			state = State.LEAVING
			took_drink.emit()
