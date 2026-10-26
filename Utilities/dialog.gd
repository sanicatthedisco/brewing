class_name Dialog extends Resource

@export var lines: Array[DLine]

func _init(p_lines: Array[DLine]):
	lines = p_lines

static func combine(dialogs: Array[Dialog]):
	var lines: Array[DLine]
	for d in dialogs:
		lines = lines + d.lines
	return Dialog.new(lines)
