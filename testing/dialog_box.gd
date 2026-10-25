
extends CanvasLayer

var dialogue = [
	"Hello, traveler!",
	"meowmeowmeow.",
    "hello?"
]

var dialogue_index = 0
var is_talking = false

@onready var dialogue_text = $Panel/Label

func _ready():
	hide()


func start_dialogue():
	dialogue_index = 0
	is_talking = true
	show()
	dialogue_text.text = dialogue[dialogue_index]


func _input(event):
	if not is_talking:
		return

	if event is InputEventKey:
		if event.pressed and not event.echo and event.keycode == KEY_SPACE:
			dialogue_index += 1

			if dialogue_index < dialogue.size():
				dialogue_text.text = dialogue[dialogue_index]
			else:
				is_talking = false
				hide()
