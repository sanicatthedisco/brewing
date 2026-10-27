class_name Character extends CharacterBody2D

@export var speech_sound = preload("res://Assets/sounds/dandys-world-classic-text-box-sound.mp3")
@export var data: JSON
var day: int = 1

signal ready_for_order
signal order_complete
signal took_drink

enum State {ORDERING, APPEARING, WAITING, EVALUATING, LEAVING}
var state: State = State.APPEARING

var move_speed = 200.0 if not GS.debug else 1000.0
var target_x = 400.0
var dialogue_started = false

@onready var dialog_loader := $DialogLoader

func _ready():
	dialog_loader._data = data.data

func _physics_process(delta: float) -> void:
	match state:
		State.APPEARING:
			if position.x < target_x:
				position.x += move_speed * delta
			else:
				send_dialog(dialog_loader.get_pre_order(day))
				state = State.ORDERING
		State.LEAVING:
			if position.x > target_x:
				position.x -= move_speed * delta
			else:
				order_complete.emit()

func recieve_order(item: IngredientContainer):
	state = State.EVALUATING
	var eval: Evaluation = dialog_loader.get_order().evaluate_container(item)

	var dialog: Array[DialogLine] = dialog_loader.get_evaluation(day, eval.score)
	if not eval.was_garnish_correct:
		dialog.append_array(dialog_loader.get_additional_evaluation(day, "incorrect_garnish"))
	if eval.amount_error > 0.2:
		dialog.append_array(dialog_loader.get_additional_evaluation(day, "small_amount"))
	
	send_dialog(dialog)

func send_dialog(dialog: Array[DialogLine]):
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
