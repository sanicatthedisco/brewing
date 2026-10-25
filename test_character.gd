extends Node2D

const lines: Array[String] = [
	"hey",
	"Wanna Sper",
	"ssfkdjd djdd",
]


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $"Area2D(interacting_area)"

var player_in_range := false
var dialog_active := false
var line_index := 0

func _ready() -> void:
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		print("player in range")

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		dialog_active = false
		line_index = 0
		print("player left range")

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("show_up"):
		return
	if not player_in_range:
		return

	# Same key starts the dialog, then advances it
	if line_index < lines.size():
		dialog_active = true
		print("NPC says: ", lines[line_index])
		# Replace the print with your dialog manager call, e.g.:
		# DialogManager.start_dialog(global_position, lines)
		line_index += 1
	else:
		dialog_active = false
		line_index = 0
		print("dialog finished")
