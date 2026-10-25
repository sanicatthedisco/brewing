
extends CharacterBody2D

@export var walk_speed: float = 150.0
@export var speech_sfx: AudioStream

@onready var sprite = $AnimatedSprite2D

var dialogue_lines: Array[String] = [
	"Hello, traveler!",
	"Welcome to my village.",
    "Would you like to explore?"
]


func _ready():
	start_sequence()


func start_sequence():
	# Start outside the left edge
	var screen_width = get_viewport_rect().size.x
	position.x = -100

	# Walk to the center
	var target_x = screen_width / 2.0

	if sprite.sprite_frames.has_animation("walk"):
		sprite.play("walk")

	var tween = create_tween()
	tween.tween_property(
		self,
		"position:x",
		target_x,
		(target_x - position.x) / walk_speed
	)

	await tween.finished

	# Stop walking
	sprite.stop()

	if sprite.sprite_frames.has_animation("idle"):
		sprite.play("idle")

	# Wait 3 seconds
	await get_tree().create_timer(3.0).timeout

	# Start dialogue
	start_dialogue()


func start_dialogue():
	var dialogue_position = global_position + Vector2(50, -150)

	dialogueManager.start_dialog(
		dialogue_position,
		dialogue_lines,
		speech_sfx
	)
