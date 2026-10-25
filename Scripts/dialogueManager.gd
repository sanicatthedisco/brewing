extends Node

signal dialog_complete

@onready var text_box_scene = preload("res://Objects/Dialogue/text_box.tscn")

enum Speaker {CUSTOMER, PROTAG}
var customer_pos := Vector2(1200, 400)
var protag_pos := Vector2(1250, 500)

var dialog: Dialog
var current_line_index = 0
var sfx: AudioStream

var text_box
 
var is_dialog_active = false
var can_advance_line = false

func start_dialog(speaker: Speaker, p_dialog: Dialog, speech_sfx: AudioStream):
	if is_dialog_active: 
		return
	dialog = p_dialog
	sfx = speech_sfx
	_show_text_box()
	
	is_dialog_active = true

func _show_text_box():

	text_box = text_box_scene.instantiate()
	text_box.scale = Vector2(3.0, 3.0)

	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	var line := dialog.lines[current_line_index]
	match line.speaker:
		Speaker.CUSTOMER:
			text_box.global_position = customer_pos
		Speaker.PROTAG:
			text_box.global_position = protag_pos
	
	text_box.display_text(line.text, sfx)
	can_advance_line = false
	
func _on_text_box_finished_displaying():
	can_advance_line = true

func _unhandled_input(event):
	if(
	event.is_action_pressed("advance_dialog") && 
	is_dialog_active && 
	can_advance_line		
	):
		text_box.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialog.lines.size():
			is_dialog_active = false
			current_line_index = 0
			dialog_complete.emit()
			return
		_show_text_box()	
