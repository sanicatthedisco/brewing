extends Node
const DIALOG_DIR := "res://Dialog"

var _data: Dictionary = {}

func _ready() -> void:
	reload()

func reload() -> void:
	_data.clear()
	var dir := DirAccess.open(DIALOG_DIR)
	assert(dir != null, "DialogLoader: can't open %s" % DIALOG_DIR)
	for fn in dir.get_files():
		if fn.get_extension() != "json":
			continue
		var parsed = _load_file(DIALOGUE_DIR.path_join(fn))
		if parsed != null:
			_data[file_name.get_basename()] = parsed

func _load_file(path: String) -> Variant:
	var text := FileAccess.get_file_as_string(path)
